var fs = require('fs');

$(function(){
    /*
     * this swallows backspace keys on any non-input element.
     * stops backspace -> back
     */
    var rx = /INPUT|SELECT|TEXTAREA/i;

    $(document).bind("keydown keypress", function(e){
        if( e.which == 8 ){ // 8 == backspace
            if(!rx.test(e.target.tagName) || e.target.disabled || e.target.readOnly ){
                e.preventDefault();
            }
        }
    });
});



window.ondragstart = function() { return false; }
var gui = require('nw.gui');
var win = gui.Window.get();
var tray = new gui.Tray({ title: 'Hands Free Leveler', icon: 'file:///C:/Hands%20Free%20Leveler/Local%20Client/Asset/img/icon.png'});

/*
tray.on('click', function() {
	win.show();
});

var tray = new gui.Tray({ title: 'Tray', icon: 'img/icon.png' });
*/
// Give it a menu
var menu = new gui.Menu();
menu.append(new gui.MenuItem({ type: 'checkbox', label: 'box1' }));
tray.menu = menu;



var app = angular.module("lc", ["ngRoute"]);
app.service('service', function(){
	this.translator = function(key){
		if(upSettings.lang){
			if(!_TRNS[upSettings.lang]){
				saveLocalSetting("lang","EN")
			}else{
				if(_TRNS[upSettings.lang][key]){
					return _TRNS[upSettings.lang][key]
				}else{
					return _TRNS["EN"][key]
				}
			}
		}else{
			saveLocalSetting("lang","EN")
		}
	}
	this.logger = function(){
		return JSON.parse(localStorage.getItem("hfl"))
	}
});

app.filter('range', function() {
  return function(input, total) {
    total = parseInt(total);
    for (var i=0; i<total; i++)
      input.push(i);
    return input;
  };
});

app.config(function($routeProvider) {
$routeProvider
	.when('/', {
	    templateUrl : 'Asset/template/splash.html',
	    controller  : 'splash'
	})
	.when('/login', {
	    templateUrl : 'Asset/template/login.html',
	    controller  : 'login'
	})
	.when('/loader', {
	    templateUrl : 'Asset/template/loader.html',
	    controller  : 'loader'
	})
	.when('/home', {
	    templateUrl : 'Asset/template/home.html',
	    controller  : 'home'
	})
});

app.controller("splash", function($scope,service,$timeout,$interval,$location){
	win.setTransparent(false);
	win.setAlwaysOnTop(true);
	winResize(600,487);
	win.setPosition("center");
	$scope.progress = 0;
	$scope.pb = $('#pbLoader').progressbar();
	var _int = $interval(function(){
        $scope.pb.progressbar('value', (++$scope.progress));
        if ($scope.progress == 100) {
        	$interval.cancel(_int);
        	$location.path('/login')
        };
    },25);
});

app.controller("console", function($scope,service,$interval){
	$scope.logs = [];

	$interval(function(){
		$scope.tlogs = service.logger()
		if($scope.tlogs.length != $scope.logs.length){
			$scope.logs = $scope.tlogs
			var box = document.getElementById('liste');
			box.scrollTop = box.scrollHeight;
		}
	},50)

});

app.controller("remote", function($scope,service){
	$scope.service = service;
});

app.controller("autoChat", function($scope,service){
	$scope.service = service;
});


app.controller("login", function($scope,service,$timeout,$location){
	$scope.service = service
	win.setAlwaysOnTop(false);
	win.setTransparent(false);
	winResize(312,518);
	win.setPosition("center");

	$scope.quit = function(){
		win.quit();
	}
	$scope.login = function(){
		$location.path('/loader')
	}
});
var selectionInProgress = false;
app.controller("loader", function($scope,$location,$interval,$timeout,service){
	$scope.service = service;
	win.setTransparent(false);
	win.setAlwaysOnTop(false);
	winResize(655,500);
	win.setPosition("center");

	$scope.part = 1;
	$scope.partLevel = 6;
	$scope.loadFunctions = [];

	var _int = $interval(function(){
		if (!selectionInProgress) {
			if($scope.part != 4 && $scope.part != 4){
				$scope.part++;
				$(".stepper").data('stepper').next();
			}
			if($scope.part == 3){
				if(settings.bolFolder){
					$scope.part++;
					$(".stepper").data('stepper').next();
				}else{
					selectionInProgress = true;
					document.getElementById("lolFolder").click();
				}

			}
			if($scope.part == 4){
				$scope.partLevel = 1;
				if(settings.bolFolder){
					$scope.part++;
					$(".stepper").data('stepper').next();
				}else{
					selectionInProgress = true;
					document.getElementById("bolFolder").click();
				}
			}
			if($scope.part == 6){
				$interval.cancel(_int)
				$timeout(function(){
					$location.path("/home");
				},1000);
			}
		};
	},500)
});

app.controller("language", function($scope,service){
	$scope.service = service;
})

app.controller("notfy", function($scope,service){
	$scope.service = service;
})

app.controller("home", function($scope,$location,$interval,$window,service){
	$scope.service = service;
	win.setTransparent(false);
	win.setAlwaysOnTop(false);
	winResize(1000,600);
	win.setPosition("center");
	$scope.smurfs = [];
	$scope.logger = logger;

	$scope.levelpattern = /as (.*?) @ level (.*?)*/;
	$scope.disconnectPattern = /.\[(.*?)\]: Disconnected/;

	$interval(function(){
		if(service.logger().length != $scope.logger.length){
			$scope.logger = service.logger();
		}
	},50);

	$scope.$watch("logger", function(e){
		for(var x = 0; x < $scope.logger.length; x++){
			var loginMatch = $scope.logger[x].match($scope.levelpattern);
			var disconnectMatch = $scope.logger[x].match($scope.disconnectPattern);
			if(loginMatch && loginMatch.length == 3){
				for(var z = 0; z < $scope.smurfs.length; z++){
					if($scope.smurfs[z].username == loginMatch[1] && !$scope.smurfs[z].working){
						$scope.smurfs[z].level = loginMatch[2];
						$scope.smurfs[z].working = "working";
					}
				}
			}
			if(disconnectMatch && disconnectMatch.length == 2){
				for(var z = 0; z < $scope.smurfs.length; z++){
					if($scope.smurfs[z].username == disconnectMatch[1]){
						$scope.smurfs[z].working = "disconnected";
					}
				}
			}
		}
	});

	$scope.status = _status;
	$scope.status.current = "Idle";
	$scope.hfl = hfl;

	$scope.hflDecide = function(){

		logger = [];
		$scope.smurfs = [];
		if(!hfl){
			$scope.smurfs = settings.smurfs;
			runHfl();
			$scope.status.current = "Working";
		}else{
			stopHfl();
			$scope.status.current = "Idle";
		}
		$scope.hfl = !$scope.hfl;
	}

	win.on("close", function(){
		if(hfl != false){
			stopHfl();
		}
		this.close(true);
	})
	//createNotify("Zigagang44 won!","Kill:13<br>Death:4<br>Assist:13");

	$(".dropdown-toggle").hover(function(){
		$(this).next("ul").css("display","block")
	});

	$(".dropdown-toggle").mouseout(function(){
		$(this).next("ul").css("display","none")
	});

	$(".dropdown-menu").hover(function(){
		$(this).css("display","block")
	})

	$(".dropdown-menu").mouseleave(function(){
		$(this).css("display","none")
	})

	$scope.lang = function(e){
		saveLocalSetting("lang",e)
	}

	$scope.remoteSettings = function(){
		var a_window = window.open('Asset/template/remote.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.notificationSettings = function(){
		var a_window = window.open('Asset/template/notification.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.gameInfoSettings = function(){
		var a_window = window.open('Asset/template/gameinfowindow.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.smurfSettings = function(){
		var a_window = window.open('Asset/template/smurf.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.champs = function(){
		var a_window = window.open('Asset/template/champs.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.autoChat = function(){
		var a_window = window.open('Asset/template/autoChat.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.news = function(){
		var a_window = window.open('Asset/template/news.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.console = function(){
		var a_window = window.open('Asset/template/console.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.stats = function(){
		var a_window = window.open('Asset/template/stats.html',{
		  "position": "center",
		  "focus": true,
		  "toolbar": true,
		  "frame": false,
		});
	}

	$scope.news();
});



app.controller("champs", function($scope,$location,service){
	$scope.service = service;
	$scope.itemList = heroList;
	$scope.champSettings = upSettings.champSettings;

	$scope.$watch("champSettings", function(){
		saveLocalSetting("champSettings",$scope.champSettings)
	}, true);

	$scope.processName = function(name){
		return name.replace(/ /g,"").replace(/\./g,"").replace(/\'/g,"").replace(/Wukong/g,"MonkeyKing");
	}

	$scope.openChamp = function(e){
		$scope.selectedHero = e;
		$scope.levelSquence = $scope.champSettings[$scope.selectedHero].leveling ? $scope.champSettings[$scope.selectedHero].leveling : [];
	}

	$scope.turnback = function(){
		$scope.selectedHero = false;
		$scope.search = "";
	}

	$scope.$watch("levelSquence",function(){
		if($scope.selectedHero){
			$scope.champSettings[$scope.selectedHero].leveling = $scope.levelSquence;
		}
	}, true)

	$scope.levelUp = function(e){
		if($scope.levelSquence.length < 18){
			$scope.levelSquence.push(e);
		}
	}

	$scope.resetLevel = function(){
		$scope.levelSquence = [];
	}
});

app.controller("smurf", function($scope,service){
	$scope.creatorMode = false;
	$scope.service = service;
	$scope.smurfs = upSettings.smurfs ?  upSettings.smurfs : [];
	$scope.contentEdit = 44444;

	$scope.creator = function(){
		$scope.creatorMode = !$scope.creatorMode;
	}

	$scope.pushUp = function(i){
		if($scope.contentEdit != 44444){
			return false;
		}
		var temp=$scope.smurfs[i-1];
		$scope.smurfs[i-1] = $scope.smurfs[i];
		$scope.smurfs[i] = temp;
	}

	$scope.pushDown = function(i){
		if($scope.contentEdit != 44444){
			return false;
		}
		var temp=$scope.smurfs[i+1];
		$scope.smurfs[i+1] = $scope.smurfs[i];
		$scope.smurfs[i] = temp;
	}

	$scope.edit = function(i){
		$scope.contentEdit = i;
	}

	$scope.del = function(i){
		$scope.smurfs.splice(i,1)
	}

	$scope.add = function(){
		var smurf = {username:"username",password:"password",dl:30}
		for(var x = 0; x < $scope.smurfs.length; x++){
			if($scope.smurfs[x].username == smurf.username){
				return false;
			}
		}
		$scope.smurfs.push(smurf)
	}

	$scope.$watch("smurfs", function(){
		saveLocalSetting("smurfs",$scope.smurfs);
		buildSmurfTable($scope.smurfs)
	}, true)
});

function buildSmurfTable(smurfs){
	fs.writeFileSync("./config/accounts.txt","");
	for(var x = 0; x < smurfs.length; x++){
		fs.appendFile("./config/accounts.txt",smurfs[x].username+"|"+smurfs[x].password+"|ARAM|"+smurfs[x].dl+"\r\n")
	}
}

function winResize(width,height){
	win.width = width;
	win.height = height;
}

function setLolFolder(path){
	fs.exists(path+ "\\lol.launcher.admin.exe",function(exists){
		if(exists){
			saveLocalSetting("gameFolder",path)
			selectionInProgress = false;
		}else{
			alert("Select folder that contains lol.launcher.admin.exe")
			document.getElementById("lolFolder").click();
		}
	});
}

function setBolFolder(path){
	fs.exists(path+ "\\BoL Studio.exe",function(exists){
		if(exists){
			saveLocalSetting("bolFolder",path)
			selectionInProgress = false;
		}else{
			alert("Select folder that contains BoL Studio.exe")
			document.getElementById("bolFolder").click();
		}
	});
}