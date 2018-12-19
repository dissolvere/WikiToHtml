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
const uuidv4 = require('uuid/v4')

// Local imports
var {mongoose} = require('./db/connect-file');
var {ConvertedFile} = require('./model/convertedFile');

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

var parse = function(){
    console.log("parse() start");
    exec.execFile('parser.exe', ['91'], function(err, data) {
        console.log(err);
        console.log(data.toString());
    });
}

var parsoid = function() {
    console.log("parsoid() start");
    exec.exec('node parsoid/bin/parse.js data/file.txt', function(err, data) {
        console.log(err);
        console.log(data.toString());
        
        fs.writeFile("data/file.txt.html", data.toString(), function(err) {
            if(err) {
                return console.log(err);
            }
        });
        convertedData = data.toString();
    });
}

//----------------------------------------------------------------------------------------------
//Upload plików jest tutaj 

app.post('/fileupload', function(req, res){
    const form = new formidable.IncomingForm();
    form.parse(req, function (err, fields, files) {
        const path = files.filetoupload.path;
        filepath = path;
        console.log(path);// to mozna wywalić
        file = files.filetoupload;
        console.log(file); // to mozna wywalic
        fs.readFile(path, 'utf8', function (err, content) {
            filecontent = content;
            console.log(content);// to mozna wywalic
        });
    });
    res.render('');
});


//upload alternative
app.post('/fileuploadalt', function(req, res) {
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
    });
});
//----------------------------------------------------------------------------------------------

app.get('/convert', function(req, res){
    parse(); // data/file.txt
    parsoid(); // data/file.txt.html
    
});
app.get('/convertTest', function(req, res){
    parsoid(); // data/file.txt.html
    
});
app.get('/save', function(req, res){

    if(convertedData === ''){
        res.render('info');
    }else {
        res.download(__dirname + '/data/file.txt.html', 'file.txt.html');
        convertedData = '';
    }

});
app.get('/show', function(req, res){

    if(convertedData === ''){
        res.render('info');
    }else{
        res.render('convertedView', {
            data: convertedData
        });
    }
    
});


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
