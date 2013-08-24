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

var userCount = 0;

var deck = _(_.range(1, 53)).shuffle().map(function(card) {
      return {
        rank: card % 13,
        suit: Math.floor(card / 13)
      };
});

io.sockets.on('connection', function(socket) {
  userCount++;

  socket.emit('userId', {userId: userCount});

  socket.on('hit', function(data) {
    socket.emit('recieveCard', deck.pop());
  });

  io.sockets.emit('newUser', {userId: userCount});

  socket.on('startGame', function() {
    console.log('dealin cards');
    socket.emit('dealCards', [deck.pop(), deck.pop(), deck.pop(), deck.pop()]);
  });
});