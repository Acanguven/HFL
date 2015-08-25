var app = angular.module("remote", ["ngRoute"]);

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
    .when('/Chat/', {
        templateUrl : 'view/chat.html',
        controller  : 'chat'
    })
    .otherwise({ redirectTo: '/Login' })
});

app.service('service', function($location){
    var _self = this;
    /* Watch feeds */
    this.user = {
        username: 1,//false
        key: 1,//false
        type:1//false
    }
    this.acc = {
        hfl: true,
        bol: true,
        rs : 3,
        ut: 154,
        ng: 12,
        wg: 12,
        smurfs:[],
        settings:{},
        items:{},
        spells:{},
        ai:{}
    }
    this.liveStatus = [];


    /* Ws */
    this.socket = new WebSocket("ws://handsfreeleveler.com:4444");
    this.socket.onopen = function (event) {
        console.log("Socket live")
    };
    this.socket.onmessage = function (msg) {
        var data = validJsonParse(msg.data);
        if(data && data.type){
            switch(data.type){
                case "access":
                    _self.user.username = data.username;
                    _self.user.key = data.key;
                    $location.path("/Dashboard")
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

app.controller("main" , function($scope,service,$location){

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

app.controller("smurfs", function($scope){

})

app.controller("dashboard", function($scope, service){
    $scope.pc = service.acc;
    $scope.$watch(function(){
        return JSON.stringify(service.acc)
    }, function(e){
        $scope.pc = service.acc;
    },true)
});

app.controller("login", function($scope,service){

    $scope.login = function(username,key){
        if(username&&key){
            service.rSend({type:"login",username:username,key:key});
        }
    };
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