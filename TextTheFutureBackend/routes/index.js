var express = require('express');
var router = express.Router();
var client = require('twilio')('**Twilio SID**', '**Twilio Auth Token**');
var Agenda = require('agenda');
var MongoClient = require('mongodb').MongoClient;
var ObjectId = require('mongodb').ObjectID;
var agenda = new Agenda({db: { address: 'localhost:27017/TextTheFuture', collection: 'MessageDB'}});
var url = 'mongodb://localhost:27017/TextTheFuture';
var assert = require('assert')

var nodeNumber = '**Number provided by twilio**';


agenda.processEvery('5 seconds');
agenda.maxConcurrency(200);
agenda.start();

var addField = function(db, id, from, message, to, when, callback) {
  db.collection('proj1').updateOne({"name" : String(id)}, 
    {
      $set: { "from" : String(from),
              "message" : String(message),
              "to" : String(to),
              "when" : String(when)
            }
          },
    function(err, results) {
      console.log("worked...");
      callback();
    });
};
var findMessages = function(db, from, callback) {
   var cursor =db.collection('MessageDB').find( { "from": String(from) } );
   var response = [];
   cursor.each(function(err, doc) {
      assert.equal(err, null);
      if (doc != null) {
        var sent = ' - Not Sent';
        if (doc.lastRunAt != null)
          sent = ' - Sent';
         response.push({"from" : doc.from,
                        "to" : doc.to,
                         "message" : doc.message,
                         "when" : doc.when,
                         "name" : doc.name,
                          "sent" : sent});
      } else {
        console.log(response)
         callback(response);
      }
   });
};
/* GET home page. */
router.get('/users/:from', function(req, res, next) {
  //res.send("got it");
  MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  findMessages(db, req.params.from,function(messages) {
      res.contentType('application/json');
      res.send(JSON.stringify(messages));
      db.close();
  });
});
  });



router.post('/', function(req,res, next){


  agenda.define(req.body.id, function(job, done) {
      client.messages.create({
        body: req.body.message,
        to: req.body.to,
        from: nodeNumber
      }, function(err, message) {
        process.stdout.write(message.sid);
      });
  });


    MongoClient.connect(url, function(err, db) {
      assert.equal(null, err);
      addField(db, req.body.id, req.body.from, req.body.message, req.body.to, req.body.when, function() {
        db.close();
        });
    });

  agenda.schedule(new Date(req.body.when), req.body.id);
  res.send('done');
});

router.post('/update', function(req,res,next) {
  agenda.cancel({name: req.body.id}, function(err, numRemoved) {
  });
  
  if (req.body.delete == 'no') {
    agenda.define(req.body.id, function(job, done) {
      client.messages.create({
        body: req.body.message,
        to: req.body.to,
        from: nodeNumber
      }, function(err, message) {
        process.stdout.write(message.sid);
      });
  });
    MongoClient.connect(url, function(err, db) {
      assert.equal(null, err);
      addField(db, req.body.id, req.body.from, req.body.message, req.body.to, req.body.when, function() {
        db.close();
        });
    });
    agenda.schedule(new Date(req.body.when), req.body.id);
  }
  res.send('everything is fine');
});

module.exports = router;
