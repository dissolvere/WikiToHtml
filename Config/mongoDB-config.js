const databaseConfig = 
{
    mongoURI: String,
    mongoName: String,
    mongoCollection: String
};

databaseConfig.mongoURI = 'mongodb://wikitohtml10:Kabareciarz123@ds153413.mlab.com:53413/wikitohtml'
databaseConfig.mongoName = 'wikitohtml'
databaseConfig.mongoCollection = 'datas'

// tutaj nie moze byc data !!! musi byc datas bo tak jest w bazie

module.exports = databaseConfig;
