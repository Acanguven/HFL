var fs = require('fs');
var _TRNS;
fs.readFile("lang.json", "utf8", function(err, data) {
    if (err) throw err;
    _TRNS = JSON.parse(data);
});	