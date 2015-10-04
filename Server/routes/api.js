var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');
mongoose.connect("mongodb://localhost:27017/db");
var db = mongoose.connection;
var fs = require("fs");
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

/* Payment Handler */
router.post("/gotPaymentpaypalIpnsecureLinkOYeah", function(req,res,next){
    if(req.body.payment_status && req.body.payment_status == "Completed"){
        if(req.body.mc_gross == "30.00"){
            Hwid.findOne({username:req.body.option_selection3}, function(err,item){
                if(!err && item){
                    item.type = 2;
                    item.markModified('type');
                    item.save();
                }
            });
        }
        if(req.body.mc_gross == "20.00"){
            Hwid.findOne({username:req.body.option_selection3}, function(err,item){
                if(!err && item){
                    item.type = 1;
                    item.markModified('type');
                    item.save();
                }
            });
        }
        if(req.body.mc_gross == "10.00"){
            if(req.body.option_selection1 && req.body.option_selection1.length > 2){
                Hwid.findOne({username:req.body.option_selection1}, function(err,item){
                    if(!err && item){
                        item.type = 2;
                        item.markModified('type');
                        item.save();
                    }
                });
            }
        }
    }
    res.end("Thanks")
});


/* Admin Router */

router.get("/sprite/:random", function(req,res,next){
    var file = __dirname + '/../public/jinxSprite.png';
    res.download(file)
});

router.get("/admin/reset/:password/" , function(req,res,next){
    if(req.params.password = "774477"){
        Hwid.find({}, function(err,items){
            items.forEach(function(item){
                item.expire = Date.now()+(1000*60*60*24);
                item.save();
            });
            res.end("done");
        });
    }
});

router.get("/admin/hwid/:password/" , function(req,res,next){
    if(req.params.password = "7744777"){
        Hwid.find({}, function(err,items){
            items.forEach(function(item){
                item.key = "false";
                item.save();
            });
            res.end("done");
        });
    }
});

router.get("/admin/make/:password/:type/:id" , function(req,res,next){
    if(req.params.password == "774477"){
        Hwid.findOne({_id:req.params.id}, function(err,item){
            if(!err && item){
                if(req.params.type === "1"){
                    item.type = 1;
                }
                if(req.params.type === "2"){
                    item.type = 2;
                }
                if(req.params.type === "0"){
                    item.type = 0;
                }
                if(req.params.type === "5"){
                    item.key = "false";
                }
                if(req.params.type === "6"){
                    item.expire = Date.now()+(1000*60*60*24);
                }
                if(req.params.type === "3"){
                    item.remove(function(){
                        res.end("done");
                    });
                }

                item.save(function(){
                    res.end("done");
                });
            }
        });
    }
});

router.get("/lawpanel/:pass", function(req,res){
    if(req.params.pass == "Metallica44!"){
        Hwid.find({}, function(err,list){
            res.render("../admin.jade", {users:list});
        });
    }else{
        res.end("<img src='http://emoticoner.com/files/emoticons/skype_smileys/bandit-skype-smiley.gif'/>");
    }
});


/* Download */
router.get("/Download", function(req,res,next){
    var file = __dirname + '../../../HFL RELEASE/HFL.rar';
    res.download(file);
});

router.get("/DownloadScript", function(req,res,next){
    var file = __dirname + '../../../ScriptsEncoded/Hands Free Leveler.lua';
    res.download(file);
});

/* Api routes. */

router.get("/acc/:username", function(req,res,next){
    Hwid.findOne({username:{ $regex : new RegExp(req.params.username, "i") }}, function(err,item){
        if(!err && item){
            if(item.type === 1 || item.type === 2){
                res.end("valid");
            }else{
                if(item.expire - Date.now() > 0){
                    res.end("valid");
                }else{
                    res.end("sorry");
                }
            }
        }else{
            res.end("sorry");
        }
    })
});

router.post('/register', function(req, res, next) {
	if(req.body.username && req.body.password){
		var newUser = new Hwid({
			username:req.body.username,
			password:req.body.password
		});
		newUser.save(function(err,item){
			if(err){
				res.json({type:"err",err:err})
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
				res.json({type:"err",err:err})
			}
		});
	}else{
		res.json({type:"err"});
	}
});

router.get("/getAI/:username/:champion/:map/:random/:version", function(req,res,next){
    var responseString = ""
    Hwid.findOne({username:req.params.username}, function(err,item){
        if(!err && item){
            fs.readFile(__dirname + '/../itemtable.lua', 'utf8', function (err,table) {
                responseString = table + "\n\n";
                responseString = responseString + createLuaSettings(item.settings,req.params.champion);
                if(req.params.map == "summonerRift"){
                    if(fs.existsSync(__dirname + '/../../ScriptsEncoded/'+req.params.version+'_sr.lua')){
                        fs.readFile(__dirname + '/../../ScriptsEncoded/'+req.params.version+'_sr.lua', 'utf8', function (err,data) {
                            responseString = responseString + "print('Loaded AI Module')";
                            responseString = responseString + "\n\n\n\n";
                            responseString = responseString + data;
                            res.end(responseString);
                        });
                    }else{
                        var errWrite = "";
                        errWrite += "print('Please tell law to update the script for the version and please send the information below to him!')";
                        errWrite += "print('Version:' .. split(GetGameVersion(),' ')[1])";
                        errWrite += "print('Region:' .. GetRegion()";
                        res.end(errWrite);
                    }
                }else{
                    if(fs.existsSync(__dirname + '/../../ScriptsEncoded/'+req.params.version+'_aram.lua')){
                        fs.readFile(__dirname + '/../../ScriptsEncoded/'+req.params.version+'_aram.lua', 'utf8', function (err,data) {
                            responseString = responseString + "print('Loaded AI Module')";
                            responseString = responseString + "\n\n\n\n";
                            responseString = responseString + data;
                            res.end(responseString);
                        });
                    }else{
                        var errWrite = "";
                        errWrite += "print('Please tell law to update the script for the version and please send the information below to him!')";
                        errWrite += "print('Version:' .. split(GetGameVersion(),' ')[1])";
                        errWrite += "print('Region:' .. GetRegion()";
                        res.end(errWrite);
                    }
                }
            });
        }else{
            res.end("")
        }
    });
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
                                if(item.type == 0 && item.expire > Date.now()){
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

/* Live home */
router.get("/client/list", function(req,res,next){
    var games = [];

    for(var game in liveGames){
        games.push(liveGames[game]);
    }

    res.json(games);
});


/* Websocket Part */

var clients = [];

var WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ port: 4444 });

wss.on('connection', function connection(ws) {
    ws.on('message', function incoming(message) {
        var data = validJsonParse(message);
        console.log(message);
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
    var res = '';
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
    
    
    if (settings.items[name] && settings.items[name].length > 0){
        res += "_ENV.aiItems={";     
        for(var x = 0; x < settings.items[name].length; x++){
            res += "itemTable[\""+settings.items[name][x].slice(1)+"\"],"
        }       
        res += "0,";
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
