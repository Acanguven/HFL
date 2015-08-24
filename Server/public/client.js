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
    .otherwise({ redirectTo: '/Login' })
});

app.service('service', function($location){
    var _self = this;
    /* Watch feeds */
    this.user = {
        username: false,
        key: false,
        type:2
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
    this.socket = new WebSocket("ws://localhost:4444");
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


app.controller("main" , function($scope,service,$location){

    $scope.loggedIn = false;
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