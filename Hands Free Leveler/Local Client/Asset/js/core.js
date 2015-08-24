//Core.js, yes really the core

var net = require('net');
var fs = require('fs');
var childProcess = require('child_process');
var hfl = false;
var logger = [];
localStorage.setItem("hfl",JSON.stringify(logger))
var settings;

var oldSettings; //watch is dangerous for nw

var _status = {
	bolRunning : false,
	runningGames : []
}
var runStr = "\""+process.cwd()+"\\hfl.exe\""

function runHfl(){
	logger = [];
	localStorage.setItem("hfl",JSON.stringify(logger))
	hfl = childProcess.exec(runStr, function (error, stdout, stderr) {
		if (error) {
			logger.push('Error code: '+error.code);
			logger.push('Signal received: '+error.signal);
			localStorage.setItem("hfl",JSON.stringify(logger))
		}
	});

	hfl.on('exit', function (code) {
		logger.push('Child process exited with exit code '+code);
		localStorage.setItem("hfl",JSON.stringify(logger))
	});

	hfl.stdout.on('data', function(data) {
	    logger.push(data.toString());
	    localStorage.setItem("hfl",JSON.stringify(logger))
	});
}

function stopHfl(){
	if(hfl != false){
		hfl.kill();
	}
	childProcess.exec("taskkill /IM hfl.exe /F");
	hfl = false;
}




function commander(cmd){
	if (cmd[0] == "status"){
		_status.bolRunning = cmd[1] == 1 ? true : false;
	}
	if (cmd[0] == "gamePing") {
		var gameIndex = _status.runningGames.findBySummoner(cmd[1]);
		if(gameIndex === false){
			if(cmd[1].length > 2){
				_status.runningGames.push({
					summoner:cmd[1],
					champion:cmd[2],
					level:cmd[3],
					x:cmd[4],
					y:cmd[5],
					gameTime:cmd[6],
					map:cmd[7],
					time:Math.floor(new Date() / 1000),
					window: window.open('Asset/template/gameWindow.html',{
					  	"focus": false,
					  	"toolbar": false,
					  	"frame": false,
					})
				});
			}
		}else{
			_status.runningGames[gameIndex].level = cmd[3];
			_status.runningGames[gameIndex].x = cmd[4];
			_status.runningGames[gameIndex].y = cmd[5];
			_status.runningGames[gameIndex].time = Math.floor(new Date() / 1000);
			_status.runningGames[gameIndex].gameTime = cmd[6];
			_status.runningGames[gameIndex].window.eval("updateWindow('"+_status.runningGames[gameIndex].summoner+"','"+_status.runningGames[gameIndex].champion+"',"+_status.runningGames[gameIndex].level+","+_status.runningGames[gameIndex].x+","+_status.runningGames[gameIndex].y+","+_status.runningGames[gameIndex].gameTime+",\""+_status.runningGames[gameIndex].map+"\")");
		}
	};
}

var runningChecker = setInterval(function(){
	if(_status.runningGames.length > 0 ){
		for(var x = 0; x < _status.runningGames.length; x++){
			if(Math.floor(new Date() / 1000) - _status.runningGames[x].time > 5){
				createNotify(_status.runningGames[x].summoner+" game ended","Kill:xx<br>Death:xx<br>Assist:xx");
				_status.runningGames[x].window.close(true);
				_status.runningGames.splice(x,1);
			}
		}
	}
},2500);

var server = net.createServer(function(socket) {
	socket.on('data', function (buffer) {
        var data = buffer.toString('utf8');
        var command = data.split("-|#|-");
        commander(command);
  	});
});

server.listen(44444, '127.0.0.1');



fs.exists("settings.json",function(exists){
	if (!exists) {
		fs.writeFile("settings.json", "{lang:\"EN\"}", function(err) {
		    if(err) {
		    	console.logger("created")
		        return console.log(err);
		    }
		    fs.readFile("settings.json", "utf8", function(err, data) {
			    if (err) throw err;
			    settings = JSON.parse(data);
			    oldSettings = JSON.stringify(settings);
			    localStorage.setItem("settings",oldSettings);
			});
		});
	}else{
		fs.readFile("settings.json", "utf8", function(err, data) {
		    if (err) throw err;
		    settings = JSON.parse(data);
		    oldSettings = JSON.stringify(settings);
		    localStorage.setItem("settings",oldSettings);
		    buildLua(settings)
		});
	}
});





function updateSettings(){
	var _upSettings = localStorage.getItem('settings');
	if(_upSettings != JSON.stringify(settings)){
		settings = JSON.parse(_upSettings); //escape binding
	}
	if (oldSettings != JSON.stringify(settings)){
		fs.writeFile("settings.json", JSON.stringify(settings), function(err) {
		    if(err) {
		        return console.log(err);
		    }
		    oldSettings = JSON.stringify(settings);
		    localStorage.setItem("settings",oldSettings);
		    buildLua(settings)
		});
	}
}

function buildLua(settings){
	if(settings.champSettings.length > 0){

	}
}



var _settingsUpdater = setInterval(updateSettings,50)


Array.prototype.findBySummoner = function(name){
	var ret = false;
	for(var x = 0; x < this.length; x++){
		if(this[x].summoner == name){
			ret = x;
		}
	}
	return ret;
}

function createNotify(title,body){
	var notif = new DesktopNotification(title, {body: body,ease: DesktopNotification.ease.easeInOutElastic, icon:"../img/splash.png"});
	notif.win.show();
	notif.show();
	notif.onshow = function(){
      setTimeout(function(){
      	notif.close.bind(notif);
      	notif.win.hide();
      }, 4000);
    };
}