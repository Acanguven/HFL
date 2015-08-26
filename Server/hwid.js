var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ObjectId = Schema.ObjectId;

var hwid = new Schema({
    username: { type: String, required: true, unique: true},
    password: { type: String, required: true},
    key: { type: String, default:"false"},
    type: { type: Number,default:0},
    settings:{type:Object,default:{}}
});


module.exports = mongoose.model('Hwid', hwid);