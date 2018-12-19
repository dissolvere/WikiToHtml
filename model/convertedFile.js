var Mongoose = require('mongoose');

var ConvertedFile = Mongoose.model('ConvertedFile', {
   text: {
    type: String
   }
});

module.exports = {ConvertedFile};