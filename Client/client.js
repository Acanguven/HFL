/* REQUIRE */
var childProcess = require('child_process');
var request = require("request");
var WebSocket = require('ws');
var fs = require('fs');

/* CONSTS */

//Cores
var HWID_EXE = "\""+process.cwd()+"\\_n1.exe\"";
var QUEUE = "\""+process.cwd()+"\\_n2.exe\"";
// Path exes
var BOL_EXE = "\""+process.cwd()+"\\_n3.exe\"";
var GAME_EXE = "\""+process.cwd()+"\\_n4.exe\"";
// CMD exes
var BOL_STARTER = "\""+process.cwd()+"\\_n5.exe\"";
var BOL_CHECKER = "\""+process.cwd()+"\\_n6.exe\"";
var PC_CONTROLLER = "\""+process.cwd()+"\\_n7.exe\"";
var USER_INFO = "\""+process.cwd()+"\\_n8.exe\"";

var VERSION = "1.0";


/* Cores */
var user = {
	hwid : "",
	username : "",
	password:""
}
var hfl;


/* FUNCTIONS */
var grabUsername = function(cb){
	var userInfo = childProcess.exec(USER_INFO);
	userInfo.stdout.on('data', function(data) {
	    cb({
	    	username:data.split("|#|")[0],
	    	password:data.split("|#|")[1]
	    })
	});
}


var grabHwid = function(cb){
	var hwidCreator = childProcess.exec(HWID_EXE);
	hwidCreator.stdout.on('data', function(data) {
	    cb(data);
	});
}

var checkAuth = function(cb){
	var url = 'http://www.handsfreeleveler.com/api/clientHwid/'+user.username+"/"+user.hwid+"/"+user.password
	request(url, function (error, response, body) {
	    if (!error && response.statusCode == 200) {
	        console.log(body);
	        if(body.indexOf("Authenticated") == 0 || body.indexOf("is now registered") > 0){
		        cb(true);
		    }else{
		    	cb(false);
		    }
	    }
	});
}

var requestSettings = function(cb){
	var url = 'http://www.handsfreeleveler.com/api/requestSettings/'+user.username+"/"+user.password
	request(url, function (error, response, body) {
		cb(JSON.parse(body));
	});
}

var udpateFolderSettings = function(gameFolder,bolFolder){
	request({
	  	uri: "http://www.handsfreeleveler.com/api/updatePaths/",
	  	method: "POST",
	  	form: {
		    gameFolder: gameFolder,
		    bolFolder: bolFolder,
		    username:user.username,
		    password:user.password
	  	}
	}, function(error, response, body){
		console.log(body);
	});
}

var deleteFolderRecursive = function(path) {
  if( fs.existsSync(path) ) {
    fs.readdirSync(path).forEach(function(file,index){
      var curPath = path + "/" + file;
      if(fs.lstatSync(curPath).isDirectory()) { // recurse
        deleteFolderRecursive(curPath);
      } else { // delete file
        fs.unlinkSync(curPath);
      }
    });
    fs.rmdirSync(path);
  }
};

var checkUpdate = function(cb){
	cb("1.0")
	// Update here
}

/* INIT */
checkUpdate(function(live_version){
	if (parseFloat(live_version) > parseFloat(VERSION)){
		console.log("New version found, please go to website and download " + live_version);
		process.stdin.setRawMode(true);
		process.stdin.resume();
		process.stdin.on('data', process.exit.bind(process, 0));
	}else{
		grabHwid(function(data){
			user.hwid = data;
		});

		grabUsername(function(data){
			user.username = data.username;
			user.password = data.password;
			console.log(data);
			checkAuth(function(res){
				if(res){
					requestSettings(function(settings){
						hfl = new HFL(user,settings);
					});
				}else{
					process.stdin.setRawMode(true);
					process.stdin.resume();
					process.stdin.on('data', process.exit.bind(process, 0));
				}
			});
		});
	}
})
var ref;
function HFL(user, settings){
	this.user = user;
	this.settings = settings;
	ref = this;
	this.filesValid = 0;
	this.started = false;
	this.starTime = Date.now()
	var queue = false;

	var ws = new WebSocket('ws://www.handsfreeleveler.com:4444');

	ws.on('open', function(){
		console.log("Connected to remote server, good luck "+ user.username);
		ref.setFiles();
		ws.send(JSON.stringify({type:"client", username: user.username,key:user.hwid}));
		setInterval(function(){
			ref.updateStatus();
		},500)
	});

	ws.on('message', function(data, flags) {
		var data = JSON.parse(data);
		if(data.type=="cmd"){
			switch(data.cmd){
				case "start queue":
					if(!ref.started){
						ref.start();
					}
				break;
			}
		}
	});

	this.checkBol = function(){
		//this.bol
	}

	this.checkQueue = function(){
		//this.started
	}

	this.updateStatus = function(){
		var status = {
/*
        hfl: true,
        bol: true,
        rs : 3,
        ut: 0,
        ng: 0,
        wg: 0,
*/
			hfl:checkHfl(),
			bol:checkBol(),
			rs:this.settings.smurfs.length,
			ut:Date.now() - this.starTime

		}
		ws.send(JSON.stringify({type:"clientUpdate",status:status,key:user.hwid,username:user.username}));
	}

	this.setFiles = function(){
		this.filesValid = 0;

		var bolfinder = childProcess.exec(BOL_EXE + " \"" + this.settings.bolFolder + "\"");
		bolfinder.stdout.on('data', function(data) {
		    ref.settings.bolFolder = data;
		    ref.filesValid++;
		    udpateFolderSettings(ref.settings.gameFolder,ref.settings.bolFolder);
		});

		var gamefinder = childProcess.exec(GAME_EXE  + " \"" + this.settings.gameFolder + "\"");
		gamefinder.stdout.on('data', function(data) {
		    ref.settings.gameFolder = data;
		    ref.filesValid++;
		    udpateFolderSettings(ref.settings.gameFolder,ref.settings.bolFolder);
		});
	}

	this.start = function(){
		if(this.filesValid == 2){
			this.starTime = Date.now()
			fs.writeFileSync("./config/accounts.txt","");
			this.settings.smurfs.forEach(function(item){
				fs.appendFileSync("./config/accounts.txt", item.username+"|"+item.password+"|ARAM|"+item.maxLevel + "\n");
			});
			var replaceSettings = fs.readFileSync("./config/settings.ini", "utf8");
			replaceSettings = replaceSettings.replace(/MaxBots=(.*)/g,"MaxBots="+this.settings.ms);
			replaceSettings = replaceSettings.replace(/Region=(.*)/g,"Region="+this.settings.rg);
			replaceSettings = replaceSettings.replace(/BuyBoost=(.*)/g,"BuyBoost="+this.settings.bb);
			var gamePathModified = this.settings.gameFolder.split("lol.launcher.admin.exe")[0];
			replaceSettings = replaceSettings.replace(/LauncherPath=(.*)/g,"LauncherPath="+gamePathModified);
			fs.writeFileSync("./config/settings.ini", replaceSettings);

			console.log("Starting auto queue system");
			this.started = true;
			ref.queue = childProcess.exec(QUEUE);

			ref.queue.stdout.on("data", function(data){
				if(data.indexOf("Error") > -1){
					ref.queue.kill();
				}
			});

			ref.queue.on("exit", function(data){
				console.log("Auto queue system failed");
				if(ref.started){
					//ref.start();
				}
			});
		}
	}
}

process.on('uncaughtException', function(e){
    console.log("Ooops an error occured, sending report the The Law so he can fix it soon!")
    //Send report here
    console.log(e);
})