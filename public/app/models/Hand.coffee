class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @trigger('hit') if !@isDealer
    @trigger('hit') if @isDealer

  stand: ->
    @trigger('endGame')

  bestScore: ->
      scores = @scores()
      if scores.length > 1 and scores[1] <= 21
        return scores[1]
      else return scores[0]

  scores: ->
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false

    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0

    hidden = !@.at(0).get('revealed')

    if hidden then return [score]
    else
      if hasAce then [score, score + 10] else [score]

  addCardToHand: (card) ->
    @add(new Card(card))
    @trigger('bust') if @scores()[0] > 21 and !@isDealer

