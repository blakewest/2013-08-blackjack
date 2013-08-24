#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set('playerHand', new Hand())
    @set('dealerHand', new Hand())

    socket = io.connect('http://localhost:3000')
    app = @

    socket.emit('startGame')

    socket.on('dealCards', (cards) ->
      card0 = new Card(cards[0])
      card1 = new Card(cards[1])
      card2 = new Card(cards[2])
      card3 = new Card(cards[3])
      app.set 'playerHand', new Hand [ card0, card1 ]
      app.set 'dealerHand', new Hand [ card2.flip(), card3 ]
      app.trigger('renderGame')
    )

    socket.on('userId', (data) ->
      app.set('userId', data.userId))

    socket.on('receiveCard', (card) ->
      app.get('playerHand').addCardToHand(card))

    @set('socket', socket)

    @get('playerHand').on('hit', @sendHit, @)
    @get('playerHand').on('endGame', @endGame, @)
    @get('playerHand').on('bust', @bust, @)

  endGame: ->
    dealer = @get('dealerHand')

    dealer.at(0).flip()

    playerScore = @get('playerHand').bestScore()

    while dealer.bestScore() < 17
      dealer.hit()

    dealerScore = dealer.bestScore()

    if playerScore > dealerScore then @trigger('playerWin')
    else
      if dealerScore > 21 then @trigger('playerWin')
      else @trigger("playerLose")

  bust: ->
    @trigger('playerLose')
    @get('dealerHand').at(0).flip()

  sendHit: ->
    @get('socket').emit('hit', {userId: @get('userId')})

