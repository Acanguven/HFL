/* REQUIRE */
var childProcess = require('child_process');
var request = require("request");
var WebSocket = require('ws');
var fs = require('fs');
var os   = require('os');
var util = require('util');
util.print("\u001b[2J\u001b[0;0H");
// CONSOLE
var clui = require('clui');
var clc = require('cli-color');
var Line          = clui.Line;
var LineBuffer    = clui.LineBuffer;
var csv = require('csv');
var Table = require('cli-table');
var Spinner = clui.Spinner;
var introText = fs.readFileSync("intro.txt", "utf-8");

//

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
var BOL_KILLER = "\""+process.cwd()+"\\_n9.exe\"";
var HFL_KILLER = "\""+process.cwd()+"\\_n10.exe\"";

var VERSION = "1.0";


/* Cores */
var user = {
	hwid : "",
	username : "",
	password:"",
	type:1
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
	var url = 'http://www.handsfreeleveler.com/api/clientHwid/'+user.username+"/"+user.hwid+"/"+user.password;
	request(url, function (error, response, body) {
	    if (!error && response.statusCode == 200) {
	        if(body.indexOf("Authenticated") == 0 || body.indexOf("is now registered") > 0){
	        	if(body.length > 20 ){
	        		user.type = 0;
	        	}else if(/(.*) (.*) /.exec(body)==null){
	        		user.type = 2;
	        	}else{
	        		user.type = 1;
	        	}
		        cb(true);
		    }else{
		    	cb(false);
		    	starter.message(clc.red(body));
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
		starter.message(body);
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


var updater;
var ref;
function HFL(user, settings){
	this.user = user;
	this.settings = settings;
	ref = this;
	this.filesValid = 0;
	this.started = false;
	this.bolWorks = false;
	this.starTime = Date.now();
	this.lastCommandsRecieved = [];
	this.smurfStatus = [];
	this.ng = 0;
	var queue = false;

	var	ws = new WebSocket('ws://www.handsfreeleveler.com:4444');
	engineStatus.message(clc.cyan("Trying to connect remote system..."));

	ws.on('open', function(){
		engineStatus.message(clc.green("Waiting commands from remote controller..."));
		ref.setFiles();
		ws.send(JSON.stringify({type:"client", username: user.username,key:user.hwid}));

		updater = setInterval(function(){
			ref.updateSettings();
			ref.updateStatus();
		},1000)
	});

	ws.on('message', function(data, flags) {
		var data = JSON.parse(data);
		if(data.type=="cmd"){
			ref.commandManager(data.cmd);
			ref.lastCommandsRecieved.unshift({time:new Date().toLocaleString(),cmd:data.cmd});
			if(ref.lastCommandsRecieved.length > 5){
				ref.lastCommandsRecieved.splice(5,99)
			}
		}
	});

	ws.on('close', function() {
	  	clearInterval(consoleUpdater);
	  	refreshConsole();
	  	engineStatus.message(clc.red("Connection with remote system closed remotely..."));
	});

	ws.on('error', function() {
	  	clearInterval(consoleUpdater);
	  	refreshConsole();
	  	engineStatus.message(clc.red("Connection with remote system crashed unexpectedly..."));
  	});


  	this.commandManager = function(cmd){
  		switch(cmd){
			case "start queue":
				if(!this.started){
					this.start();
					this.ng = 0;
				}
			break;
			case "stop queue":
				if(this.started){
					this.started = false;
					ref.queue.kill();
					childProcess.exec(HFL_KILLER);
					for(var x in this.smurfStatus){
						if(this.smurfStatus[x] && this.smurfStatus[x].status){
							this.smurfStatus[x].status = clc.red("Terminated");
						}
					}
				}
			break;
			case "close bol":
				childProcess.exec(BOL_KILLER);
			break;
			case "start bol":
				childProcess.exec(BOL_STARTER  + " \"" + this.settings.bolFolder + "\"" + " \""+ this.settings.bolFolder.split("BoL Studio.exe")[0] + "\"");
			break;
		}
  	}


	this.checkBol = function(){
		var bolChecker = childProcess.exec(BOL_CHECKER);
		bolChecker.stdout.on("data", function(data){
			if(data == "true"){
				ref.bolWorks = true;
			}else{
				ref.bolWorks = false;
			}
		});
	}

	this.updateStatus = function(){
		this.checkBol();
		var smurfUpdate = [];
		for(var prop in this.smurfStatus){
			smurfUpdate.push(this.smurfStatus[prop]);
		}
		//smurfUpdate = JSON.stringify(smurfUpdate);

		var status = {
			hfl:this.started,
			bol:this.bolWorks,
			rs:this.settings.smurfs.length,
			ut:Date.now() - this.starTime,
			ng:this.ng,
			wg:0,
			smurfUpdate:smurfUpdate
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
		if(this.filesValid == 2 && this.started == false){
			this.starTime = Date.now()
			fs.writeFileSync("./config/accounts.txt","");
			this.settings.smurfs.forEach(function(item){
				fs.appendFileSync("./config/accounts.txt", item.username+"|"+item.password+"|INTRO_BOT|"+item.maxLevel + "\r\n");
			});
			var replaceSettings = fs.readFileSync("./config/settings.ini", "utf8");
			replaceSettings = replaceSettings.replace(/MaxBots=(.*)/g,"MaxBots="+this.settings.ms);
			replaceSettings = replaceSettings.replace(/Region=(.*)/g,"Region="+this.settings.rg);
			replaceSettings = replaceSettings.replace(/ReplaceConfig=(.*)/g,"ReplaceConfig="+this.settings.gpuD)
			replaceSettings = replaceSettings.replace(/BuyBoost=(.*)/g,"BuyBoost="+this.settings.bb);
			var gamePathModified = this.settings.gameFolder.split("lol.launcher.admin.exe")[0];
			replaceSettings = replaceSettings.replace(/LauncherPath=(.*)/g,"LauncherPath="+gamePathModified);
			fs.writeFileSync("./config/settings.ini", replaceSettings);

			//console.log("Starting auto queue system");
			this.started = true;

			ref.queue = require('child_process').spawn('cmd',["/c","_n2.exe"]);

			ref.queue.stdout.on("data", function(data){
				if(data){
					data = data.toString("utf-8");
					if(data.indexOf("Error") > -1){
						ref.queue.kill();
						childProcess.exec(HFL_KILLER);
						ref.started = false;
					}else{
						if(data.indexOf("|#|") > 0){
							ref.queueStatusUpdater(data);
						}
					}
				}
			});

			ref.queue.on("exit", function(data){
				ref.started = false;
			});
		}
	}

	this.queueStatusUpdater = function(data){
		//Update smurfs status here!

		/*
			usernamepassfail

		*/
		var dataArr = data.split("|#|");
		
		if(dataArr.length > 0){
		    var user = dataArr.pop();
		    var type = dataArr[0];
		    var msg = dataArr.join(" ")
    		if(!this.smurfStatus[user] && !~user.indexOf("[")){
    			this.smurfStatus[user] = {status:clc.red("Waiting"),level:1}
    		}
    		this.smurfStatus[user].username = user;
		    switch(type){
		    	case "Disconnected":
		    		this.smurfStatus[user].status = clc.red("Disconnected");
		    		this.smurfStatus[user].statusText = "Disconnected";

		    		setTimeout(function(){
		    			if(ref.started){
		    				var stillWork = false;
				    		for(var prop in ref.smurfStatus){
				    			if (ref.smurfStatus[prop].statusText != "Disconnected"){
				    				stillWork = true;
				    			}
				    		}
				    		if(!stillWork){
				    			ref.commandManager("stop queue")
				    		}
		    			}
		    		},10000)
		    		
		    	break;
		    	case "leaverbusted":
		    		this.smurfStatus[user].status = clc.red("Leaver Busted");
		    		this.smurfStatus[user].statusText = "Leaver Busted";
		    	break;
		    	case "champselect":
		    		this.smurfStatus[user].status = clc.yellow("Selecting Champion");
		    		this.smurfStatus[user].statusText = "Selecting Champion";
		    	break;
		    	case "postchamp":
		    		this.smurfStatus[user].status = clc.yellow("Last Champion Select");
		    		this.smurfStatus[user].statusText = "Last Champion Select";
		    	break;
		    	case "prechamp":
		    		this.smurfStatus[user].status = clc.green("Champion Selection Done");
		    		this.smurfStatus[user].statusText = "Champion Selection Done";
		    	break;
		    	case "inq":
		    		this.smurfStatus[user].status = clc.yellow("In Queue");
		    		this.smurfStatus[user].statusText = "In Queue";
		    	break;
		    	case "requeue":
		    		this.smurfStatus[user].status = clc.yellow("Joined Queue Again");
		    		this.smurfStatus[user].statusText = "Joined Queue Again";
		    	break;
		    	case "accepted":
		    		this.smurfStatus[user].status = clc.green("Game Accepted");
		    		this.smurfStatus[user].statusText = "Game Accepted";
		    	break;
		    	case "startinglol":
		    		this.smurfStatus[user].status = clc.yellow("Starting game");
		    		this.smurfStatus[user].statusText = "Starting game";
		    	break;
		    	case "queue":
		    		this.smurfStatus[user].status = clc.yellow("In "+dataArr[1]+ " Queue");
		    		this.smurfStatus[user].statusText = "In "+dataArr[1]+ " Queue";
		    	break;
		    	case "restartlol":
		    		this.smurfStatus[user].status = clc.red("Restarting Game");
		    		this.smurfStatus[user].statusText = "Restarting Game";
		    	break;
		    	case "connecting":
		    		this.smurfStatus[user].status = clc.yellow("Connecting");
		    		this.smurfStatus[user].statusText = "Connecting";
		    	break;
		    	case "sumdone":
		    		this.smurfStatus[user].status= clc.cyan("Smurfing Done");
		    		this.smurfStatus[user].statusText = "Smurfing Done";
		    	break;
		    	case "loggedinlevel":
		    	case "levelup":
		    		this.smurfStatus[user].level = dataArr[1];
		    	break;
		    	case "gameended":
		    		this.ng++;
		    	break;
		    }			
		}
	}

	this.updateConsole = function(){
		refreshConsole();
		process.stdout.write(this.headerCreator() + this.updateUsageStats() + this.smurfStats() + this.lastCommands());
	}


	/* Console Trackers */
	this.headerCreator = function(){
	  	var table = new Table({
		    head: ['Username', 'Account Type', 'Start Time']
		});
		table.push(
		    [ user.username, "Trial Account", new Date().toLocaleString()]
		);
		return table.toString()+"\n";
	}


	this.updateUsageStats = function(){
		// Ram Update
		var GaugeRam = clui.Gauge;
		var total = os.totalmem();
		var used = this.startMeasureRAM - os.freemem() >= 0 ? this.startMeasureRAM - os.freemem() : 0;
		var human = Math.ceil(used / 1000000) + ' MB';
		var ramGraph = GaugeRam(used, total, 30, total * 0.8, human);

		// Cpu Update
		var endMeasure = this.cpuAverage();
		var GaugeCpu = clui.Gauge;

		var idleDifference = endMeasure.idle - this.startMeasureCPU.idle;
		var totalDifference = endMeasure.total - this.startMeasureCPU.total;
		var human = 100 - ~~(100 * idleDifference / totalDifference) + " %";
		var total = totalDifference;
		var free = idleDifference;
		var used = total - free >= 0 ? total - free : 0;
		var cpuGraph = GaugeCpu(used, total, 30, total * 0.8, human);

		//Table
	    var table = new Table({
		    head: ['','Based on changes after HFL started']
		});
		table.push(
		    { 'RAM Usage': ramGraph },
		   	{ 'CPU Usage': cpuGraph}
		);

		return table.toString()+"\n";
	}



	this.cpuAverage = function() {
	  var totalIdle = 0, totalTick = 0;
	  var cpus = os.cpus();
	  for(var i = 0, len = cpus.length; i < len; i++) {
	    var cpu = cpus[i];
	    for(type in cpu.times) {
	      totalTick += cpu.times[type];
	   }
	    totalIdle += cpu.times.idle;
	  }
	  return {idle: totalIdle / cpus.length,  total: totalTick / cpus.length};
	}

	this.startMeasureRAM = os.freemem();
	this.startMeasureCPU = this.cpuAverage();


	this.smurfStats = function() {

		//Table
	    var table = new Table({
		    head: ['#', 'Username', 'Password', 'Max\nLevel', 'Current\nLevel', 'Queue Status']
		    //colWidths: [5, 10,10,5,5,10]
		});
		for(var x = 0; x < this.settings.smurfs.length; x++){
			var arr = [this.settings.smurfs[x].username,this.settings.smurfs[x].password,this.settings.smurfs[x].maxLevel,this.smurfStatus[this.settings.smurfs[x].username] && this.smurfStatus[this.settings.smurfs[x].username].level ? clc.cyan(this.smurfStatus[this.settings.smurfs[x].username].level) : '1',this.smurfStatus[this.settings.smurfs[x].username] && this.smurfStatus[this.settings.smurfs[x].username].status ? this.smurfStatus[this.settings.smurfs[x].username].status : clc.yellow('Idle')]
			arr.unshift(x+1);
			table.push(arr)
		}

		return table.toString()+"\n";
	}

	this.lastCommands = function() {
		//Table
	    var table = new Table({
		    head: ['#', 'Time', 'Commands Recieved']
		});
		for(var x = 0; x < this.lastCommandsRecieved.length; x++){
			var arr = [this.lastCommandsRecieved[x].time,this.lastCommandsRecieved[x].cmd];

			arr.unshift(x+1);
			table.push(arr)
		}

		return table.toString()+"\n";
	}

	this.updateSettings = function(){
		requestSettings(function(data){
			ref.settings = data;
		});
	}

}



var refreshConsole = function(){
	//console.log( "\u001b[2J\u001b[0;0H");
	//process.stdout.write("\u001b[2J\u001b[0;0H");

	process.stdout.write('\033c');
	process.title = "Hands Free Leveler | " + VERSION;
}



/* INIT */
refreshConsole();
var starter = new Spinner('Getting user details...');
var engineStatus = new Spinner(clc.green("Starting system..."));
console.log(clc.green(introText))
starter.start();
var consoleUpdater;



checkUpdate(function(live_version){
	if (parseFloat(live_version) > parseFloat(VERSION)){
		starter.message("New version found, please go to website and download " + live_version);
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

			checkAuth(function(res){
				if(res){
					requestSettings(function(settings){
						starter.stop();
  						engineStatus.start();
						hfl = new HFL(user,settings);
						consoleUpdater = setInterval(function(){
							hfl.updateConsole();
						},1000);
					});
				}
			});
		});
	}
})


/* Process Handlers */

process.on('uncaughtException', function(e){
    //console.log("Ooops an error occured, sending report the The Law so he can fix it soon!");
    fs.appendFile('errors.txt', JSON.stringify(e));
    console.log(e)
    //Send report here
});