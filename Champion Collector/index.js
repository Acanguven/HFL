/* Settings */

var host = "http://leagueoflegends.wikia.com";
var MAX_OPEN_REQUEST = 5;

/* Dont touch below */

var request = require('request');
var cheerio = require('cheerio');
var fs = require('fs');

var outList = [];
var inList = [];
var lastChamp = "";
var _t;

request("http://leagueoflegends.wikia.com/wiki/List_of_champions", function(err, resp, body){
	$ = cheerio.load(body);
	$(".stdt .character_icon").each(function(){
		inList.push($(this).children("a").attr("title"))
	});
	_t = setInterval(syncManager,100)
});

function syncManager(){
	if(inList.length > 0){
		if(lastChamp != inList[0]){
			parseImg(inList[0]);
		}
	}else{
		clearInterval(_t);
	}
}

function parseImg(name){
	console.log("Working on "+ name + "| Remains: " + inList.length)
	lastChamp = name;
	request("http://leagueoflegends.wikia.com/wiki/"+name, function(err, resp, body){
		$ = cheerio.load(body);
		var img = $("#image img").attr("src");
		downloadImg(img,name+".png",function(){
			inList.splice(0,1);
		});
	});
}

var downloadImg = function(uri, filename, callback){
  request.head(uri, function(err, res, body){
    request(uri).pipe(fs.createWriteStream("img/" + filename)).on('close', callback);
  });
};