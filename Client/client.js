/* REQUIRE */
var prompt = require('prompt');
var childProcess = require('child_process');
var request = require("request");

/* CONSTS */
var HWID_EXE = "\""+process.cwd()+"\\_n1.exe\"";
var VERSION = "1.0";


/* Cores */
var user = {
	hwid : "",
	username : ""
}


/* FUNCTIONS */
var grabUsername = function(cb){
	prompt.get(['username'], function (err, result) {
	    if (err) { return onErr(err); }
	    cb(result.username);
	});
}


var grabHwid = function(cb){
	var hwidCreator = childProcess.exec(HWID_EXE);
	hwidCreator.stdout.on('data', function(data) {
	    cb(data);
	});
}

var checkAuth = function(cb){
	var url = 'http://www.handsfreeleveler.com/api/clientHwid/'+user.username+"/"+user.hwid
	request(url, function (error, response, body) {
	    if (!error && response.statusCode == 200) {
	        console.log(body); // Show the HTML for the Modulus homepage.
	    }
	});
	//cb(false,"yey")
}

var checkUpdate = function(cb){
	cb("1.0")
	// Update here
}

/* INIT */
prompt.start();

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
			user.username = data;
			checkAuth(function(res,msg){
				if(res){
					console.log("start Process")
				}else{
					console.log(msg);
					process.stdin.setRawMode(true);
					process.stdin.resume();
					process.stdin.on('data', process.exit.bind(process, 0));
				}
			});
		});
	}
})
