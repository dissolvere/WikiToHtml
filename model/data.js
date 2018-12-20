var mongoose = require('mongoose');
const {Schema}= mongoose;

const Data = new Schema ({
    id:String,
    parser: String
});

module.exports = mongoose.model('data', Data);