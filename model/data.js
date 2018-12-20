var mongoose = require('mongoose');
const {Schema}= mongoose;

const Data = new Schema ({
    id:String,
    parser: String
});

mongoose.model('data', Data);