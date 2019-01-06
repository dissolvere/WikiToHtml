var mongoose = require('mongoose');
const {Schema}= mongoose;

const ConvertedFile = new Schema ({
   text: {
      type: String
   }
});

module.exports = mongoose.model('convertedFile', ConvertedFile);