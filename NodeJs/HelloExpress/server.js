var express = require('express');
var app = express();
var port = 3000;

app.listen(port, function(){
    console.log('Express app is listening on port: ' + port);
});

app.get('/', function(request, response){
    response.send('Hello, World!. This is for the GET call.');
});

app.get('/test', function(request, response){
    response.send('Hello there');
});