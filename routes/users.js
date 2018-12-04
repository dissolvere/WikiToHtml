var express = require('express');
var router = express.Router();

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

module.exports = router;


//HEROKU
//https://pure-depths-40700.herokuapp.com/ | https://git.heroku.com/pure-depths-40700.git