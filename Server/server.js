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

app.use(logger({path: __dirname +"/logs/logger.txt"}));
app.use( bodyParser.json() );       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));


function strongHash(text){
    return sha256(md5(sha256.x2(md5(sha1(text)))));
}

app.use(function(req,res,next){
    console.log(req.url)
    next();
})
/* serves main page */
app.get("/itemtables", function(req,res){
    res.sendFile(__dirname + "/itemtables.html");
})

app.get("/remote", function(req, res) {
    res.sendFile( __dirname + '/index.html')
});

app.get("/client", function(req, res) {
    res.end("Get ready to release...")
});

app.get("/client2", function(req, res) {
    res.sendFile( __dirname + '/client.html')
});

app.use('/api', api);


app.post("/gotPaymentpaypalIpnsecureLink", function(req,res){
    var keyGenerated = "46846312168943144354683434";
    if(req.body.payment_status && req.body.payment_status == "Completed"){
        transporter.sendMail({
            from: 'thelaw@handsfreeleveler.com',
            to: 'ahmetcanguven44@gmail.com',
            subject: 'Hands Free Leveler Key',
            text: 'Thank you for buying Hands Free Leveler, here is your key. \n\n 44554646551123134856 \n\n You can reedem the key from http://www.handsfreeleveler.com'
        });
    }
    res.end("thanks");
});

 /* serves all the static files */
app.use(express.static('public'));

var port = 80;
app.listen(port, function() {
    console.log("Listening on " + port);
});



/* Handler */

process.on('uncaughtException', function(e){
    console.log(JSON.stringify(e, null, ' '))
})