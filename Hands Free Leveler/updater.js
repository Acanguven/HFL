var http = require('http');
var fs = require('fs');

var sourceList = JSON.parse(fs.readFileSync('https://raw.githubusercontent.com/thelaw44/HandsFreeLeveler/master/sourceList.json', 'utf8'));

var file = fs.createWriteStream("file.jpg");
var request = http.get("http://i3.ytimg.com/vi/J---aiyznGQ/mqdefault.jpg", function(response) {
  response.pipe(file);
});