var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
mongoose.connect('mongodb://zikenziemaster:Metallica44!@ds059712.mongolab.com:59712/hfl');
var db = mongoose.connection;
var Schema = mongoose.Schema;
var jwt = require('jsonwebtoken');
var TOKEN_KEY = "i wanna be the very best 44";
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function (callback) {
  console.log("connection to db open")
  //Database Sıfırlama Kodu, HER ŞEY SİLİNECEKTİR DİKKATLİ KULLAN
  //db.db.dropDatabase(); //Db refresher
});
var Hwid = require("../hwid.js");

/* Api routes. */

router.post('/register', function(req, res, next) {
	if(req.body.username && req.body.password){
		var newUser = new Hwid({
			username:req.body.username,
			password:req.body.password
		});
		newUser.save(function(err,item){
			if(err){
				res.json({type:"err",err:err.message})
			}else{
				var token = jwt.sign(item, TOKEN_KEY);
				res.json({type:"user",username:item.username,settings:item.settings,key:item.key,usertype:item.type,token:token})
			}
		});
	}else{
		res.json({type:"err"})
	}
});

router.post("/login", function(req,res,next){
	if(req.body.username && req.body.password){
		Hwid.findOne({username:req.body.username}, function(err,item){
			if(item){
				var token = jwt.sign(item, TOKEN_KEY);
				res.json({type:"user",username:item.username,settings:item.settings,key:item.key,usertype:item.type,token:token})
			}else{
				res.json({type:"err",err:err.message})
			}
		});
	}else{
		res.json({type:"err",err:err.message})
	}
});

router.post("/getSettings", function(req,res,next){
    if(req.body.token){ 
        jwt.verify(req.body.token, TOKEN_KEY, function(err, decoded) {
            if(!err){
                if(decoded){
                    res.end(JSON.stringify(decoded.settings));
                }
            }
        });   
    }
});

router.post("/saveSettings", function(req,res,next){
    if(req.body.token && req.body.settings){ 
        jwt.verify(req.body.token, TOKEN_KEY, function(err, decoded) {
            if(!err){
                if(decoded){
                    decoded.settings = req.body.settings;
                    if (decoded.type === 1 || decoded.type === 4){
                        decoded.settings.ms = 1;
                    }
                    Hwid.findOne({_id:decoded._id}, function(e,item){
                        if(!e && item){
                            item.settings = decoded.settings;
                            item.save(function(er,saved){
                                res.end("done") 
                            });
                        }
                    })
                }
            }
        });   
    }
});



/* Client Routes */

router.get("/clientHwid/:username/:hwid/:password", function(req,res,next){
    Hwid.findOne({username:req.params.username}, function(err,item){
        if(err){
            res.end("Be sure that you registered from website. Go to handsfreeleveler.com");
        }else{
            if(item){
                if(item.password == req.params.password){
                    if(item.key == "false"){
                        item.key = req.params.hwid;
                        item.save(function(){
                            res.end("Your computer is now registered to your account");
                        });
                    }else{
                        if(item.key == req.params.hwid){
                            res.end("Authenticated user");
                        }else{
                            res.end("You cant use your account on a different computer");
                        }
                    }
                }else{
                    res.end("Password rejected")
                }
            }else{
                res.end("Be sure that you registered from website. Go to handsfreeleveler.com");
            }
        }
    })
});

router.get("/requestSettings/:username/:password", function(req,res,next){
    Hwid.findOne({username:req.params.username,password:req.params.password}, function(err,item){
        if(!err){
            if(item){
                res.json(item.settings);
            }
        } 
    });
});

router.post("/updatePaths", function(req,res,next){
    if(req.body.username && req.body.password){
        Hwid.findOne({username:req.body.username, password:req.body.password}, function(err,item){
            if(!err && item){
                item.settings.gameFolder = req.body.gameFolder,
                item.settings.bolFolder = req.body.bolFolder
                item.markModified('settings');
                item.save(function(err,saved){
                    res.end("Path settings updated");
                });
            }
        })
    }
});




/* Websocket Part */

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
                        ws.key = data.key;
                        clients[data.key].username = data.username;
                    }
                break;
                
                case "remoteUpdate":
                    if(data.username && data.key){
                        if(clients[data.key]){
                            ws.send(JSON.stringify({type:"update",status:clients[data.key].status}));
                        }else{
                            ws.send(JSON.stringify({type:"powerOFF"}));
                        }
                    }
                break;
                
                case "clientUpdate":
                    if(data.username && data.key){
                        clients[data.key].status = data.status;
                    }
                break;
                
                case "cmd":
                    clients[data.key].send(message);
                break;
            }
        }
    });
    
    ws.on('close', function close() {
        delete clients[ws.key];
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



module.exports = router;
