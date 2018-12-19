var Mongoose = require('mongoose');

var ConvertedFile = Mongoose.model('ConvertedFile', {
   text: String
});

module.exports = {ConvertedFile};