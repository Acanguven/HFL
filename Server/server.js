var express = require("express");
var app = express();
var logger = require('express-logger');
var bodyParser = require("body-parser");
var nodemailer = require('nodemailer');
var md5 = require('MD5');
var sha1 = require('sha1');
var sha256 = require("sha256");
var transporter = nodemailer.createTransport();

app.use(logger({path: __dirname +"/public/logger.txt"}));


function strongHash(text){
    return sha256(md5(sha256.x2(md5(sha1(text)))));
}

app.use(bodyParser.urlencoded({ extended: false }));
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


app.post("/user/add", function(req, res) { 
    /* some server side logic */
    res.send("OK");
});



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


var clients = [];

var WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ port: 4444 });

wss.on('connection', function connection(ws) {
    
    ws.on('message', function incoming(message) {
        var data = validJsonParse(message);
        if (data && data.type){
            switch(data.type){
                case "login":
                    if(data.username && data.key){
                        if(clients[data.key]){
                            if(clients[data.key].username == data.username){
                                ws.send(JSON.stringify({type:"access",username:data.username,key:data.key}));
                            }else{
                                ws.send(JSON.stringify({type:"err",msg:"Your client is running but your username is wrong"}));
                            }
                        }else{
                            ws.send(JSON.stringify({type:"err",msg:"Your client is not running"}));
                        }
                    }else{
                        ws.send(JSON.stringify({type:"err",msg:"Username or key not defined"}));
                    }
                break;
                
                case "client":
                    if(data.username && data.key){
                        clients[data.key] = ws;
                        clients[data.key].username = data.username;
                    }
                break;
            }
        }
    });
});

function validJsonParse(str){
    var jsn = false;
    try{
        jsn = JSON.parse(str);
    }catch(e){
        return false;
    }
    return jsn;
}