var express = require("express");
var app = express();
var logger = require('express-logger');
var bodyParser = require('body-parser')
var nodemailer = require('nodemailer');
var md5 = require('MD5');
var sha1 = require('sha1');
var sha256 = require("sha256");
var transporter = nodemailer.createTransport();
var api = require('./routes/api');
var jade = require("jade");

//app.use(logger({path: __dirname +"/logs/logger.txt"}));
app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));
app.set('view engine', 'jade')


function strongHash(text){
    return sha256(md5(sha256.x2(md5(sha1(text)))));
}


app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

app.use(function(req,res,next){
    //console.log(req.url)
    next();
})
/* serves main page */
app.get("/itemtables", function(req,res){
    res.sendFile(__dirname + "/itemtables.html");
})


/* Update Timer */

/*
app.use(function(req,res,next){
    var ipnumber = req.ip
    if(ipnumber !=  "176.33.236.85"){
        res.end("Down for update, it will be open in 3 hours." + "<small>"+ipnumber+"</small>");
    }else{
        next();
    }
});
*/

app.get("/remote", function(req, res) {
    res.sendFile( __dirname + '/index.html')
});

app.get("/client", function(req, res) {
    res.sendFile( __dirname + '/client.html')
});

app.get("/admin", function(req,res){
    res.send("<img src='http://emoticoner.com/files/emoticons/skype_smileys/bandit-skype-smiley.gif'/>");
});


app.use('/api', api);


 /* serves all the static files */
app.use(express.static('public'));

var port = 80;
app.listen(port, "0.0.0.0" ,function() {
    console.log("Listening on " + port);
});



/* Handler */

process.on('uncaughtException', function(e){
    console.log(e)
})
