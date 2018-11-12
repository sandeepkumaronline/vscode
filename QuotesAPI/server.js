// imports
var express = require('express');
var bodyParser = require('body-parser');
var sqlite3 = require('sqlite3');
var app = express();

// mounts BodyParser as middleware - every request passes through it
app.use(bodyParser.urlencoded({ extended: true }));

// variables
var port = 3000;

// Connect to Database
var db = new sqlite3.Database('quotes.db');

// ROUTES

app.get('/', function(req, res){
    res.send("GET request received at '/' ");
});

// GET /quotes
app.get('/quotes', function(req, res){
    if(req.query.year){
        db.all('SELECT * FROM myQuotes WHERE year = ?', [req.query.year], function(err, rows){
            if(err){
                res.send(err.message);
            }
            else{
                console.log("Return a list of quotes from the year: " + req.query.year);
                res.json(rows);
            }
        });
    }
    else{
        db.all('SELECT * FROM myQuotes', function processRows(err, rows){
            if(err){
                res.send(err.message);
            }
            else{
                for( var i = 0; i < rows.length; i++){
                    console.log(rows[i].quote);
                }
                res.json(rows);
            }
        });
    }
});

// GET /quotes/:id
app.get('/quotes/:id', function(req, res){
    console.log("return quote with the ID: " + req.params.id);
    db.get('SELECT * FROM myQuotes WHERE rowid = ?', [req.params.id], function(err, row){
        if(err){
            console.log(err.message);
        }
        else{
            res.json(row);
        }
    });
});

// POST /quotes
app.post('/quotes', function(req, res){
    console.log("Insert a new quote: " + req.body.quote);
    db.run('INSERT INTO myQuotes VALUES (?, ?, ?)', [req.body.quote, req.body.author, req.body.year], function(err){
        if(err){
            console.log(err.message);
        }
        else{
            res.send('Inserted quote with id: ' + this.lastID);
        }
    });
});

app.listen(port, function(){
    console.log('Express app is listening on port: ' + port);
});

// app.get('/quotes', function(req, res){
//     if(req.query.year){
//         res.send("Return a list of quotes from the year: " + req.query.year);
//     }
//     else{
//         res.json(quotes);
//     }
// });

// app.get('/quotes/:id', function(req, res){
//     console.log("Return quote with the ID: " + req.params.id);
//     res.send("Return quote with the ID: " + req.params.id);
// });

// app.post('/quotes', function(req, res){
//     console.log("Insert a new quote: " + req.body.quote);
//     res.json(req.body);
// });

// var quotes = [
//     {
//         id: 1,
//         quote: "The best is yet to come. This is quote at id 1",
//         author: "Unknown",
//         year: 2000
//     },
//     {
//         id: 2,
//         quote: "This is a quote at id 2",
//         author: "First Last",
//         year: 1930
//     },
//     {
//         id: 3,
//         quote: "This is another quote at id 3",
//         author: "First2 Last2",
//         year: 1910
//     }
// ];