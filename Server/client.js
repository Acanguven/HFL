var app = angular.module("remote", []);

app.controller("main" , function($scope){
   var remoteSocket = new WebSocket("ws://handsfreeleveler.com:4444");
});