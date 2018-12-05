var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var exec = require('child_process').execFile;
var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

var convertedData = '';
var fun = function(){
    console.log("fun() start");
    exec('parser.exe', ['91'], function(err, data) {
        console.log(err)
        console.log(data.toString());
    });
}
//zmieńcie sobie odpowiednio metody get/post/...
app.get('/upload', function(req, res){
    res.json("Radek");
});
app.get('/convert', function(req, res){
    fun();
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
