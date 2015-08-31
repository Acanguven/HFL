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
		Hwid.findOne({username:req.body.username, password:req.body.password}, function(err,item){
			if(item){
				var token = jwt.sign(item, TOKEN_KEY);
				res.json({type:"user",username:item.username,settings:item.settings,key:item.key,usertype:item.type,token:token})
			}else{
				res.json({type:"err",err:err.message})
			}
		});
	}else{
		res.json({type:"err"});
	}
});

router.get("/getAI/:username/:champion/:map", function(req,res,next){
    Hwid.findOne({username:req.params.username}, function(err,item){
        if(!err && item){
            res.end(createLuaSettings(item.settings,req.params.champion));
        }else{
            res.end("")
        }
    })
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
                        Hwid.findOne({key:req.params.hwid}, function(er3,reitem){
                            if(reitem){
                                res.end("Your computer is already registered to an account");
                            }else{
                                item.key = req.params.hwid;
                                item.save(function(){
                                    res.end("Your computer is now registered to your account");
                                });
                            }
                        });
                    }else{
                        if(item.key == req.params.hwid){
                            if(item.type == 1 || item.type == 2){
                                if(item.type == 2){
                                    res.end("Authenticated user");
                                }else{
                                    res.end("Authenticated user ");
                                }
                            }else{
                                if(item.type == 0 && item.expire < Date.now()){
                                    res.end("Authenticated trial user");
                                }else{
                                    res.end("Your trial account is ended");
                                }
                            }
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


/* Live controller */

var liveGames = [];
var gamesDumper = setInterval(function(){
    for(var x in liveGames){
        if(liveGames[x].expireTime < Date.now()){
            delete liveGames[x];
        }
    }
},2000);

router.get("/liveStats/:username/", function(req,res,next){
    var smurfs = [];
    for(var x in liveGames){
        if(liveGames[x].user == req.params.username){
            smurfs.push(liveGames[x]);
        }
    }
    res.json(smurfs);
});

router.get("/updateChat/:gameCode/:chatText", function(req,res,next){
    if(liveGames[req.params.gameCode]){
        liveGames[req.params.gameCode].chat.push(req.params.chatText);
    }
});

router.get("/updateLive/:user/:hero/:map/:gameCode/:x/:z/:time/:level/:kill/:death/:assist/:mininon", function(req,res,next){
    if(!liveGames[req.params.gameCode]){
        liveGames[req.params.gameCode] = {};
    }
    for (var attrname in req.params) { liveGames[req.params.gameCode][attrname] = req.params[attrname]; }
    liveGames[req.params.gameCode].expireTime = Date.now() + 1000 * 6;
    if(!liveGames[req.params.gameCode].chat){
        liveGames[req.params.gameCode].chat = [];
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

createLuaSettings = function(settings,name){
    var res = "";
    if(settings.ai[name]){
        res += "_ENV.aiAggr="+settings.ai[name].aggr+"\n"
        res += "_ENV.aiLane=\""+settings.ai[name].lane+"\"\n"
    }
    if(settings.spells[name]){
        res += "_ENV.aiSpells={";     
        for(var x = 0; x < settings.spells[name].length; x++){
            switch(settings.spells[name][x]){
                case "Q":
                    res += "1";
                break;
                case "W":
                    res += "2";
                break;
                case "E":
                    res += "3";
                break;
                case "R":
                    res += "4";
                break;
            }
            res += ","
        }
        res += "}\n"
    }
    
    
    if (settings.items[name]){
        res += "_ENV.aiItems={";     
        for(var x = 0; x < settings.items[name].length; x++){
            res += "\""+settings.items[name][x].slice(1)+"\","
        }       
        res += "}\n";
    }
    
    if(settings.chat){
        res += "_ENV.chats = {}\n";
        for(prop in settings.chat){
            if(prop != "init"){
                res += "_ENV.chats[\""+prop+"\"] = {"
                for(var x = 0 ; x < settings.chat[prop].length; x++){
                       res += ("{chance=" + settings.chat[prop][x].chance + "," + "text=\"" + settings.chat[prop][x].text.replace(/\"/g,"")+"\"},")
                }
                res += "}\n"
            }
        }
    }
    return res;
}



module.exports = router;
