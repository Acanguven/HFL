var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ObjectId = Schema.ObjectId;

var hwid = new Schema({
    username: { type: String, required: true, unique: true},
    password: { type: String, required: true},
    key: { type: String, default:"false"},
    type: { type: Number,default:0},
    settings:{type:Object,default:
        {        
            smurfs:[],
            items:{init:true},
            spells:{init:true},
            ai:{init:true},
            bb:false,
            rg:"EUW",
            ms:1,
            bolFolder:"",
            gameFolder:"",
            gpuD:false,
            chat:{init:true}
        }
    },
    expire:{type:String,default:Date.now()+(1000*60*60*24)}
});


module.exports = mongoose.model('Hwid', hwid);