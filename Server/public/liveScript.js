var app = angular.module("home", []);

app.controller("main", function($scope,$http,$interval){
	$scope.selectedSmurf = 0;
	$scope.changeSmurf = 0;
	$scope.init = "valid";
	$http.get("http://handsfreeleveler.com/api/client/list").then(function(data){
		$scope.liveSmurfs = data.data;
	});
	$interval(function(){
		$http.get("http://handsfreeleveler.com/api/client/list").then(function(data){
			$scope.liveSmurfs = data.data;
		});
	},1000);

	$scope.$watch("changeSmurf", function(){
		if($scope.liveSmurfs){
			if($scope.liveSmurfs[$scope.selectedSmurf]){
				$scope.selectedSmurf  = $scope.changeSmurf
			}else{
				$scope.selectedSmurf = 0;
				$scope.changeSmurf = 0;
			}
        }
	});

	$interval(function(){
		if($scope.liveSmurfs){
	    	if($scope.liveSmurfs[$scope.selectedSmurf]){
	            var livex = $scope.liveSmurfs[$scope.selectedSmurf].x;
	            var livez = $scope.liveSmurfs[$scope.selectedSmurf].z;
	            var map = $scope.liveSmurfs[$scope.selectedSmurf].map;
	            if(map == "summonerRift"){
	                var mapX = $("#currentmap").width()*livex/14716;
	                var mapZ = $("#currentmap").height()*livez/14824;
	                $(".heroMarker").css({top: $("#currentmap").height()-mapZ-10, left: mapX-10});
	            }
	        }
	    }
    },500)

	$scope.timeParser = function(i){
		var minutes = ~~i/60;
		var seconds = parseInt(i%60);
		return minutes + ":" + seconds;
	}
});