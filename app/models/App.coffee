#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @get('playerHand').on('endGame', @endGame, @)
    @get('playerHand').on('bust', @bust, @)

  endGame: ->
    #find score of both player and dealer
    #compare scores and display winner
    #flip any covered cards from dealer

    bestScore = (hand) ->
      scores = hand.scores()
      if scores.length > 1 and scores[1] <= 21
        return scores[1]
      else return scores[0]

    dealer = @get('dealerHand')

    dealer.at(0).flip()

    playerScore = bestScore(@get('playerHand'))


    while bestScore(dealer) < 17
      dealer.hit()

    dealerScore = bestScore(dealer)

    if playerScore > dealerScore then @trigger('playerWin')
    else
      if dealerScore > 21 then @trigger('playerWin')
      else @trigger("playerLose")



  bust: ->
    @trigger('playerLose')
    @get('dealerHand').at(0).flip()

