var mongoose = require('mongoose');
const {Schema}= mongoose;

const ConvertedFile = new Schema ({
   text: String
});

mongoose.model('convertedFile', ConvertedFile);