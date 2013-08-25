var express = require('express');
var http = require('http');

var app = express();
var server = app.listen(3000);
var io = require('socket.io').listen(server);
var _ = require('underscore');

app.use(express.static(__dirname + "/public"));

app.get("/", function(request, response) {
  response.sendfile(__dirname + "/index.html");
});

var cardValues = [10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10];
var deck;
var marker;

var shuffleDeck = function() {
  deck = _(_.range(1, 261)).shuffle().map(function(card) {
    return {
      rank: card % 13,
      suit: Math.floor(card / 13) % 4
    };
  });

  marker = Math.floor(Math.random() * 60) + 156;
};

shuffleDeck();

var bestScore = function(scores) {
  if (scores.length > 1 && scores[1] <= 21) {
    return scores[1];
  }
  else {
    return scores[0];
  }
};

io.sockets.on('connection', function(socket) {

  socket.on('hit', function(data) {
    socket.emit('receiveCard', deck.pop());
  });

  socket.on('startGame', function() {
    if(deck.length < marker) {
      shuffleDeck();
    }
    socket.emit('dealCards', [deck.pop(), deck.pop(), deck.pop(), deck.pop()]);
  });

  socket.on('stand', function(scores) {
    var cards = [];

    while(bestScore(scores) < 17) {
      var card = deck.pop();
      cards.push(card);
      for(var i = 0; i < scores.length; i++) {
        scores[i] += cardValues[card["rank"]];
      }
    }
    socket.emit('endGame', cards);
  });

});