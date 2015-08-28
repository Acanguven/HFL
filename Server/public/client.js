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
        rg:false,
        ms:1
    }
    this.acc = {
        hfl: true,
        bol: true,
        rs : 3,
        ut: 0,
        ng: 0,
        wg: 0,
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
        console.log("Socket live")
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

app.controller("account", function($scope,service,$http){
    $scope.user = service.user;
    $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
        service.settings = response.data;
        $scope.user = service.user;
    });
});

app.controller("settings", function($scope, service,$http){
    $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
        service.settings = response.data;
    });
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

app.controller("chat", function($scope,service,$routeParams){
    $scope.eventType = "ondead";
    $scope.repeater = createArr(1,100);
    $scope.chats = [];
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

    $scope.removeChat = function(id){
        $scope.chats[$scope.eventType].splice(id,1);
    }

    $scope.getChats = function(){
        return $scope.chats[$scope.eventType];
    }
});

app.controller("spells", function($scope,service,$routeParams){
    $scope.champ = $routeParams.champion;

    $scope.levelSpell = [];

    $scope.add = function(i){
        $scope.levelSpell.push({key:i});
    }

    $scope.remove = function(i){
        $scope.levelSpell.splice(i,1);
    }
});

app.controller("behaviours", function($scope,service,$routeParams){
    $scope.champ = $routeParams.champion;

});

app.controller("items", function($scope,service,$routeParams,$location,$http){
    $scope.champ = $routeParams.champion;
    if(!$scope.champ || $scope.champ.length < 1){
        $location.path("/Dashboard")
    }
    $scope.items = [];
    $http.get("/items.json").then(function(response){
        response.data.forEach(function(item){
            item.queue = 4444;
            $scope.items.push(item)
        });
    });
    $scope.itemRow = [];

    $scope.clickItem = function(item){
        if(item.selected === true){
            item.selected = false;
            var index = $scope.itemRow.indexOf(item.name);
            $scope.itemRow.splice(index,1)
            item.queue = 4444;
        }else{
            item.selected = true;
            $scope.itemRow.push(item.name)
            item.queue = $scope.itemRow.indexOf(item.name);
        }
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
        console.log(service.remote)
    },100);
    
    $scope.loggedIn = (service.user.username && service.user.key) ? true : false;
    $scope.$watch(function(){
        return JSON.stringify(service.user)
    }, function(e){
        $scope.loggedIn = (service.user.username && service.user.key) ? true : false;
        if(!$scope.loggedIn){
            $location.path("/Login");
            $scope.form = 1;
        }else{
            $scope.form = 2;
        }
    },true)

    $scope.formC = function(id){
        $scope.form = id;
    }
});

app.controller("live", function($scope){

})

app.controller("smurfs", function($scope,$http,service,$interval){
    $scope.smurfs = service.settings.smurfs;

    $http.post("/api/getSettings/", {token:service.user.token}).then(function(response){
        service.settings = response.data;
    });

    $scope.saveSettings = function(){
        service.settings.smurfs = $scope.smurfs;
        $http.post("/api/saveSettings", {token:service.user.token, settings:service.settings}).then(function(response){
            alert("Settings Saved");
        });
    }
});

app.controller("dashboard", function($scope, service,$interval){
    $interval(function(){
        $scope.pc = service.acc;
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