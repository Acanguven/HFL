var app = angular.module("remote", ["ngRoute"]);


var _int1 = false;
app.config(function($routeProvider) {
    $routeProvider
    .when('/Dashboard', {
        templateUrl : 'view/dashboard.html',
        controller  : 'dashboard'
    })
    .when('/Login', {
        templateUrl : 'view/login.html',
        controller  : 'login'
    })
    .when('/LiveController', {
        templateUrl : 'view/livecontroller.html',
        controller  : 'live'
    })
    .when('/SmurfList', {
        templateUrl : 'view/smurflist.html',
        controller  : 'smurfs'
    })
    .when('/Champions/:redirect', {
        templateUrl : 'view/champions.html',
        controller  : 'champions'
    })
    .when('/Items/:champion', {
        templateUrl : 'view/items.html',
        controller  : 'items'
    })
    .when('/Behaviours/:champion', {
        templateUrl : 'view/behaviours.html',
        controller  : 'behaviours'
    })
    .when('/Spells/:champion', {
        templateUrl : 'view/spells.html',
        controller  : 'spells'
    })
    .when('/Chat', {
        templateUrl : 'view/chat.html',
        controller  : 'chat'
    })
    .when('/Settings', {
        templateUrl : 'view/settings.html',
        controller  : 'settings'
    }).when('/Account', {
        templateUrl : 'view/account.html',
        controller  : 'account'
    })
    .when('/Sharing', {
        templateUrl : 'view/share.html',
        controller  : 'share'
    })
    .otherwise({ redirectTo: '/Login' })
});

app.service('service', function($location,$interval){
    var _self = this;
    /* Watch feeds */
    this.user = {
        username: false,//false
        key: false,//false
        type:false,//false
        token:false
    }
    this.settings = {
        smurfs:[],
        items:{},
        spells:{},
        ai:{},
        bb:false,
        behaviours:{},
        rg:false,
        ms:1,
        chat:{}
    }
    this.acc = {
        hfl: true,
        bol: true,
        rs : 3,
        ut: 0,
        ng: 0,
        wg: 0,
        smurfUpdate:[],
        //Update api down
        smurfs:[],
        items:{},
        spells:{},
        ai:{},
        bb:false,
        rg:false,
        ms:1,
        gpuD:false
    }
    this.liveStatus = [];
    this.remote = 0;


    /* Ws */
    this.socket = new WebSocket("ws://handsfreeleveler.com:4444");
    this.socket.onopen = function (event) {
        _int1 = setInterval(function(){
            _self.rSend({type:"remoteUpdate",key:_self.user.key,username:_self.user.username})
        },1000);
    };
    this.socket.onmessage = function (msg) {
        var data = validJsonParse(msg.data);
        if(data && data.type){
            switch(data.type){
                case "access":
                    _self.user.username = data.username;
                    _self.user.key = data.key;
                break;

                case "update":
                    if(_self.remote === false){
                        alert("Your client is live now");
                    }
                    _self.remote = true;
                    _self.acc.hfl = data.status.hfl;
                    _self.acc.bol = data.status.bol;
                    _self.acc.rs = data.status.rs;
                    _self.acc.ut = ~~(data.status.ut/60000);
                    _self.acc.ng = data.status.ng;
                    _self.acc.wg = data.status.wg;
                    _self.acc.smurfUpdate = data.status.smurfUpdate;
                    if(_self.acc.smurfUpdate.length > 0){
                        for(var x = 0; x < _self.settings.smurfs.length; x++){
                            for(var z = 0; z < _self.acc.smurfUpdate.length; z++){
                                if(_self.settings.smurfs[x].username == _self.acc.smurfUpdate[z].username){
                                    _self.settings.smurfs[x].currentLevel = _self.acc.smurfUpdate[z].level;
                                    _self.settings.smurfs[x].statusText = _self.acc.smurfUpdate[z].statusText;
                                }
                            }
                        }
                    }
                break;
                
                case "powerOFF":
                    if(_self.remote === true){
                        alert("Lost connection to your client, please start it from your computer");
                    }
                    _self.remote = false;
                break;

                case "err":
                    alert(data.msg);
                break;
            }
        }
    };
    this.rSend = function(obj){
        var jst = JSON.stringify(obj);
        if(jst){
            this.socket.send(jst);
        }
    };
});

app.controller("share", function($scope,service,$http){
    var shareCode = {};
    shareCode.chat = service.settings.chat;
    shareCode.spells = service.settings.spells;
    shareCode.items = service.settings.items;
    shareCode.ai = service.settings.ai;
    $scope.exported = JSON.stringify(shareCode);

    $scope.imported = function(data){
        importObj = JSON.parse(data);
        if(importObj){
            service.settings.chat = importObj.chat;
            service.settings.spells = importObj.spells;
            service.settings.items = importObj.items;
            service.settings.ai = importObj.ai;

            $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
                alert("Settings are imported");
            });
        }
    }
});

app.controller("account", function($scope,service,$http){
    $scope.user = service.user;
    $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
        service.settings = response.data;
        $scope.user = service.user;
    });
});

app.controller("settings", function($scope, service,$http){
    $scope.fullUser = service.user.type !== 1;
    $scope.buyBoost = String(service.settings.bb);
    $scope.region = service.settings.rg;
    $scope.gpuDisable = String(service.settings.gpuD);
    $scope.limitSmurf = service.user.type !== 1 ? createArr(1,100) : [1];
    $scope.maxSmurf = service.settings.ms;
    $scope.$watch("maxSmurf", function(){
        if($scope.maxSmurf > 1 && service.user.type === 1){
            alert("Please 25$ is not that much high. Please respect developers work!");
            $scope.maxSmurf = 1;
        }
    });

    $scope.saveSettings = function(){
        service.settings.ms = $scope.maxSmurf;
        service.settings.bb = $scope.buyBoost;
        service.settings.rg = $scope.region;
        service.settings.gpuD = $scope.gpuDisable;

        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved")
        });
    }
});

app.controller("chat", function($scope,service,$routeParams,$http){
    $scope.eventType = "ondead";
    $scope.repeater = createArr(1,100);
    $scope.chats = service.settings.chat;
    if(!$scope.chats[$scope.eventType]){
        $scope.chats[$scope.eventType] = [];
    }


    $(document).ready(function() {
        $("div.bhoechie-tab-menu>div.list-group>a").click(function(e) {
            e.preventDefault();
            $(this).siblings('a.active').removeClass("active");
            $(this).addClass("active");
            var eventT = $(this).attr('event');
            $scope.$apply(function(){
                $scope.eventType = eventT
                if(!$scope.chats[eventT]){
                    $scope.chats[eventT] = [];
                }
            });
        });
    });

    $scope.addChat = function(text,chance){
        $scope.chats[$scope.eventType].push({text:text,chance:chance});
    }

    $scope.save = function(){
        service.settings.chat = $scope.chats;
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }

    $scope.removeChat = function(id){
        $scope.chats[$scope.eventType].splice(id,1);
    }

    $scope.getChats = function(){
        return $scope.chats[$scope.eventType];
    }
});

app.controller("spells", function($scope,service,$routeParams,$http){
    $scope.champ = $routeParams.champion;

    $scope.levelSpell = [];
    if(service.settings.spells[$scope.champ]){
        for(var x = 0; x < service.settings.spells[$scope.champ].length; x++){
           $scope.levelSpell.push({key:service.settings.spells[$scope.champ][x]});
        }
    }


    $scope.add = function(i){
        if($scope.levelSpell.length < 18){
            $scope.levelSpell.push({key:i});
        }
    }

    $scope.save = function(){
        if(!service.settings.spells[$scope.champ]){
            service.settings.spells[$scope.champ] = [];
        }
        for(var x = 0; x < $scope.levelSpell.length; x++){
            service.settings.spells[$scope.champ].push($scope.levelSpell[x].key);
        }

        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }

    $scope.clear = function(){
        delete service.settings.spells[$scope.champ];
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
            $scope.levelSpell = [];
        });
        
    }

    $scope.remove = function(i){
        $scope.levelSpell.splice(i,1);
    }
});

app.controller("behaviours", function($scope,service,$routeParams,$http){
    $scope.champ = $routeParams.champion;
    $scope.aggr = service.settings.ai[$scope.champ] && service.settings.ai[$scope.champ].aggr ? service.settings.ai[$scope.champ].aggr : 0;
    $scope.lane = service.settings.ai[$scope.champ] && service.settings.ai[$scope.champ].lane ? service.settings.ai[$scope.champ].lane : "Bot";

    $scope.save = function(aggr,lane){
        if(!service.settings.ai[$scope.champ]){
            service.settings.ai[$scope.champ] = {};
        }
        service.settings.ai[$scope.champ].aggr = aggr;
        service.settings.ai[$scope.champ].lane = lane;
        
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });

    }

    $scope.clear = function(){
        delete service.settings.ai[$scope.champ];
        alert("Deleted champion settings, now system will use default settings. You don't need to press save again.")
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }
});

app.controller("items", function($scope,service,$routeParams,$location,$http){
    $scope.champ = $routeParams.champion;
    if(!$scope.champ || $scope.champ.length < 1){
        $location.path("/Dashboard")
    }
    $scope.itemRow = service.settings.items[$scope.champ] ? service.settings.items[$scope.champ] : [];
    $scope.items = [];
    $http.get("/items.json").then(function(response){
        response.data.forEach(function(item){
            item.queue = 4444;
            if(~$scope.itemRow.indexOf(item.name)){
                item.queue =  $scope.itemRow.indexOf(item.name);
                item.selected = true;
            }
            $scope.items.push(item)
        });
    });

    $scope.clickItem = function(item){
        $scope.itemRow.push(item.name)
    }

    $scope.removeItem = function(index){
        $scope.itemRow.splice(index,1)
    }

    $scope.getItemPng =  function(name){
        for(var x = 0; x < $scope.items.length; x++){
            if($scope.items[x].name == name){
                return $scope.items[x].png
            }
        }
    }

    $scope.save = function(){
        if(!service.settings.items[$scope.champ]){
            service.settings.items[$scope.champ] = [];
        }
        service.settings.items[$scope.champ] = $scope.itemRow;
        
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }

    $scope.clear = function(){
        delete service.settings.items[$scope.champ];
        $scope.itemRow = [];
        for(var x = 0; x < $scope.items.length; x++){
            $scope.items[x].selected = false;
        }
        alert("Deleted champion settings, now system will use default settings. You don't need to press save again.")
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }
});

app.controller("champions", function($scope,service,$location,$routeParams,$http){
    $scope.champions = [];
    $http.get("/champs.json").then(function(response){
        response.data.forEach(function(champ){
            $scope.champions.push({name:champ, img:"/img/"+champ+".png"})
        });
    });
    $scope.redirect = function(name){
        $location.path("/"+$routeParams.redirect+"/"+name)
    }
});

app.controller("main" , function($scope,service,$location,$interval){

    $interval(function(){
        $scope.remote = service.remote;
    },100);
    
    $(function() {
        $('.nav a').on('click', function(){ 
            if(!$(this).hasClass("dropdown-toggle")){
                if($('.navbar-toggle').css('display') !='none'){
                    $(".navbar-toggle").trigger( "click" );
                }
            }
        });
    });

    
    $scope.loggedIn = (service.user.username && service.user.key) ? true : false;
    $scope.$watch(function(){
        return JSON.stringify(service.user)
    }, function(e){
        $scope.loggedIn = (service.user.username && service.user.key) ? true : false;
        if(!$scope.loggedIn){
            $location.path("/Login");
        }
    },true)

    $scope.form = 9;

    $scope.formC = function(id){
        $scope.form = id;
    }
});

app.controller("live", function($scope,$interval,service,$http){
    $scope.remoted = service.remote;
    $scope.liveData = [];
    $scope.selectedCode = false;
    $interval(function(){
        $scope.remoted = service.remote;
    },500);
    $interval(function(){
        $scope.updateData();
    },1500);

    $scope.updateData = function(){
        $http.get("/api/liveStats/"+service.user.username).then(function(response){
            $scope.liveData = response.data;
            console.log(response.data)
            if($scope.selectedCode === false && $scope.liveData.length>0){
                $scope.selectedCode = $scope.liveData[0].gameCode;
            }
            var exists = false;
            for(var x = 0; x < $scope.liveData.length; x++){
                if($scope.selectedCode == $scope.liveData[x].gameCode){
                    exists = true;
                }
            }
            if(!exists){
                $scope.selectedCode = false;
            }

            if($scope.selectedCode !== false){
                var livex = $scope.showSmurf().x;
                var livez = $scope.showSmurf().z;
                var map = $scope.showSmurf().map;

                if(map == "summonerRift"){
                    var mapX = $("#currentmap").width()*livex/14716;
                    var mapZ = $("#currentmap").height()*livez/14824;
                    $(".heroMarker").css({top: $("#currentmap").height()-mapZ, left: mapX});
                }else{

                }

            }
        });
    }

    $scope.select = function(smurf){
        $scope.selectedCode = smurf.gameCode;
    }    

    $scope.showSmurf = function(){
        for(var x = 0; x < $scope.liveData.length; x++){
            if($scope.selectedCode == $scope.liveData[x].gameCode){
                $scope.liveData[x].time = ~~$scope.liveData[x].time;
                return $scope.liveData[x]
            }
        }
    }
});

app.controller("smurfs", function($scope,$http,service,$interval){
    $scope.smurfs = service.settings.smurfs;

    $scope.saveSettings = function(){
        service.settings.smurfs = $scope.smurfs;
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }
});

app.controller("dashboard", function($scope, service,$interval){
    $scope.remoted = service.remote;
    $scope.pc = service.acc;
    $interval(function(){
        $scope.pc = service.acc;
        $scope.remoted = service.remote;
    },500)

    $scope.sendCmd = function(id){
        if(id === 1){
            if ($scope.pc.bol){
                service.rSend({type:"cmd",cmd:"close bol",key:service.user.key});
            }else{
                service.rSend({type:"cmd",cmd:"start bol",key:service.user.key});
            }
        }

        if(id === 2){
            if($scope.pc.hfl){
                service.rSend({type:"cmd",cmd:"stop queue",key:service.user.key});
            }else{
                service.rSend({type:"cmd",cmd:"start queue",key:service.user.key});
            }
        }
        
        if(id == 3){
            if(prompt("Are you sure y/n") == "y"){
                service.rSend({type:"cmd",cmd:"stop pc",key:service.user.key});
            }
        }
    }
});

app.controller("login", function($scope,service,$http,$location){
    $scope.login = function(username,pass){
        $http.post("/api/login", {username:username,password:pass}).then(function(response){
            if(response.data.type == "user"){
                service.user.username = response.data.username;
                service.user.key = response.data.key;
                service.user.type = response.data.usertype;
                service.user.token = response.data.token;
                service.rSend({type:"login",username:service.user.username, key:service.user.key});
                $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
                    service.settings = response.data;
                    console.log(response.data)
                    $location.path("/Account");
                });
            }else{
                alert("Check your login details");
            }
        });
    };

    $scope.register = function(username,p1,p2){
        if(p1 == p2){
            $http.post("/api/register", {username:username,password:p1}).then(function(response){
                if(response.data.type == "user"){
                    service.user.username = response.data.username;
                    service.user.key = response.data.key;
                    service.user.type = response.data.usertype;
                    service.user.token = response.data.token;
                    service.rSend({type:"login",username:service.user.username, key:service.user.key});
                    $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
                        service.settings = response.data;
                        console.log(response.data)
                        $location.path("/Account");
                    });
                }else{
                    alert("Error registering your account, check your inputs")
                }
            });
        }
    }
});

function validJsonParse(str){
    var jsn = false;
    try{
        jsn = JSON.parse(str);
    }catch(e){
        jsn = false;
    }
    return jsn;
};

function createArr(s,e){
    var arr = [];
    for(s; s <= e; s++){
        arr.push(s);
    }
    return arr;
}