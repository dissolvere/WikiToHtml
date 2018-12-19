var mongoose = require('mongoose');

// jesli na kompie uruchomiony jest mongod(mamy baze mongoDb) to wtedy odkomentowac

 mongoose.Promise = global.Promise;
 mongoose.connect('mongodb://wikitohtml10:Kabareciarz123@ds153413.mlab.com:53413/wikitohtml');

module.exports = { mongoose };

