class window.Deck extends Backbone.Collection

  model: Card

  initialize: ->
    # make whole deck from shuffling array of shuffled num.
    # input rank and suit properties to the card object. return as array.
    # use backbone add method to give the collection the whole 'deck'
    @add _(_.range(1, 53)).shuffle().map (card) ->
      new Card
        rank: card % 13
        suit: Math.floor(card / 13)

  # pop two cards off of the deck and make a new hand
  dealPlayer: -> hand = new Hand [ @pop(), @pop() ], @

  # pop two cards off of the deck and make a new hand
  # flip the first
  dealDealer: -> new Hand [ @pop().flip(), @pop() ], @, true
