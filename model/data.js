var mongoose = require('mongoose');
const {Schema}= mongoose;

const Data = new Schema ({
    id:{
        type:String
    },
    parser: {
        type: String
    }
});

module.exports = mongoose.model('data', Data);