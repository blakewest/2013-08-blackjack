#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set('playerHand', new Hand())
    @set('dealerHand', new Hand())

    socket = io.connect('http://localhost:3000')
    app = @

    socket.emit('startGame')

    socket.on 'dealCards', (cards) ->
      card0 = new Card(cards[0])
      card1 = new Card(cards[1])
      card2 = new Card(cards[2])
      card3 = new Card(cards[3])
      app.set 'playerHand', new Hand [ card0, card1 ]
      app.set 'dealerHand', new Hand [ card2.flip(), card3 ]
      app.setHandlers()
      app.trigger 'renderGame'

    socket.on 'userId', (data) ->
      app.set 'userId', data.userId

    socket.on 'receiveCard', (card) ->
      console.log('recieved new card')
      console.log(card)
      app.get('playerHand').addCardToHand(card)

    socket.on 'endGame', (cards) -> app.endGame(cards)

    @set 'socket', socket

  setHandlers: ->
    @get('playerHand').on 'hit', @sendHit, @
    @get('playerHand').on 'stand', =>
      app = @
      app.get('dealerHand').at(0).flip()
      app.get('socket').emit('stand', app.get('dealerHand').scores())
    @get('playerHand').on 'bust', @bust, @

  endGame: (cards) ->
    dealer = @get 'dealerHand'
    dealer.add(new Card(card)) for card in cards
    dealerScore = dealer.bestScore()

    playerScore = @get('playerHand').bestScore()


    if playerScore > dealerScore then @trigger 'playerWin'
    else
      if dealerScore > 21 then @trigger 'playerWin'
      else @trigger("playerLose")

  bust: ->
    @trigger('playerLose')
    @get('dealerHand').at(0).flip()

  sendHit: ->
    console.log('are we sending')
    @get('socket').emit('hit', {userId: @get('userId')})

  playAgain: ->
    @get('socket').emit('startGame')
    console.log("this will actually give you a new game")

