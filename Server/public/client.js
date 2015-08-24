var app = angular.module("remote", []);

app.controller("main" , function($scope){
    $scope.remoteSocket = new WebSocket("ws://handsfreeleveler.com:4444");
    $scope.form = 2;
    $scope.user = {
        username:false,
        key:false,
    };
    
    $scope.pc = {
        hfl: true,
        bol: true,
        rs : 3,
        ut: 154,
        ng: 12,
        wg: 12,
        smurfs:[]
    }
    
   
    $scope.remoteSocket.onopen = function (event) {
        $scope.rSend({type:"welcome"});
    };
    
    $scope.login = function(username,key){
        if(username&&key){
            $scope.rSend({type:"login",username:username,key:key});
        }
    };
    
    $scope.rSend = function(obj){
        var jst = JSON.stringify(obj);
        if(jst){
            $scope.remoteSocket.send(jst); 
        }
    };
    
    $scope.remoteSocket.onmessage = function (msg) {
        var data = validJsonParse(msg.data);
        if(data && data.type){
            switch(data.type){
                case "access":
                    $scope.$apply(function(){
                        $scope.user.username = data.username;
                        $scope.user.key = data.key;
                        $scope.form = 2;
                    });
                break;
                
                case "err":
                    alert(data.msg);
                break;
            }
        }
    };
    
    $scope.formC = function(i){
        $scope.form = i;
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