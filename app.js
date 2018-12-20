// Global imports
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var exec = require('child_process');
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var formidable = require('formidable');
var fs = require('fs');
var bodyParser = require('body-parser');
var busboy = require('connect-busboy');
var nodePandoc = require('node-pandoc');
var sourceToPandoc, argsToPandoc, callbackFromPandoc;
const uuidv4 = require('uuid/v4')
const mongoose = require('mongoose');


var databaseConfig = require('./Config/mongoDB-config');

const ConvertedFile = require('./model/convertedFile');
const DateParser = require('./model/data');
mongoose.connect(databaseConfig.mongoURI);

var app = express();

app.use(busboy());

var filecontent = "";
var filepath = "";
var file ;

var convertedData = '';

// view engine setup
app.use(bodyParser.json());


function setFileName(req, resp) {
    return uuidv4();
}

var parse = function(id){
    console.log("parse() start");
    exec.execFile('./parser/parser.exe', ['../data/'+id, databaseConfig.mongoURI, databaseConfig.mongoName, databaseConfig.mongoCollection, id], function(err, data) {
        console.log(err);
        console.log(data.toString());
    });
}


var pandoc = function(id){
    let filePandoc;
    DateParser.findOne({id:req.body.id})
        .then(One => {
            if(One){
                One.parser = filePandoc;
            }else{
                res.json({error:'Nie ma w bazie!!!'})
            }

        })
}

//Pandoc
argsToPandoc = '-f tikiwiki -t html5';
callbackFromPandoc = function (err, result) {

    if (err) {
        console.error('Oh Nos: ',err);
    }
// tutaj zapis do zmienneji bazy
    console.log(result);
    return result;
};
// to wkleisc do wywolania
//pandoc(sourceToPandoc, argsToPandoc, callbackFromPandoc);
//----------------------------------------------------------------------------------------------
app.post('/fileupload', function(req, res) {
    var fstream;
    req.pipe(req.busboy);
    req.busboy.on('file', function (fieldname, filecontent, filename) {
        console.log("Uploading: " + filename);
        file = setFileName();
        fstream = fs.createWriteStream(__dirname + '/data/' + file);
        filecontent.pipe(fstream);
        console.log("Writing: " + file);
        fstream.on('close', function () {
            res.redirect('back');
        });
        parse(file);
        pandoc(file);
    });
});
//----------------------------------------------------------------------------------------------

// example post method for db
app.post('/data', (req,res) => {

    var dataTmp = new ConvertedFile({
        text: req.body.text
    });

    dataTmp.save().then((doc) => {
        res.send(doc);
    }, (e) => {
        res.status(400).send(e);
    });
})




app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


const PORT = process.env.PORT||5000;
app.listen(PORT, () => {
    console.log('Started on port 5000');
});


module.exports = app;
