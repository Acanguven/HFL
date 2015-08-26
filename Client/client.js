/* REQUIRE */
var prompt = require('prompt');
var childProcess = require('child_process');
var request = require("request");
var WebSocket = require('ws');

/* CONSTS */
var HWID_EXE = "\""+process.cwd()+"\\_n1.exe\"";
var VERSION = "1.0";


/* Cores */
var user = {
	hwid : "",
	username : ""
}
var hfl;


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
	cb(true,"")
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
					hfl = new HFL(user);
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

function HFL(user){
	this.user = user;
	this.ws = new WebSocket('ws://www.handsfreeleveler.com:4444');
	this.ws.on('open', function open() {
		console.log("Connected to remote server")
	});
}
