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

var app = express();


//////tu są zmienne które potrzebujesz filecontent, filepath i file wybieraj
var filecontent = "";
var filepath = "";
var file ;

var convertedData = '';

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
    });
}
//zmieńcie sobie odpowiednio metody get/post/...
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

app.get('/convert', function(req, res){
    parse(); // data/file.txt
    parsoid(); // data/file.txt.html
    convertedData = 'dane przekonwertowane';
});
app.get('/convertTest', function(req, res){
    parsoid(); // data/file.txt.html
    convertedData = 'dane przekonwertowane';
});
app.get('/save', function(req, res){

    if(convertedData === ''){
        res.render('info');
    }else {
        res.download(__dirname + '/upload-folder/convertedFile.txt', 'convertedFile.txt');
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



// view engine setup
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


const PORT=process.env.PORT||3000;
app.listen(PORT);

module.exports = app;
