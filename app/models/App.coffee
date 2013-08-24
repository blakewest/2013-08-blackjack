#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
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

