class window.AppView extends Backbone.View

  template: _.template '
    <button class="hit-button">Hit</button> <button class="stand-button">Stand</button>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .playAgain": -> @model.playAgain()

  initialize: ->
    @model.on 'playerLose', @playerLose, @
    @model.on 'playerWin', @playerWin, @
    @model.on 'renderGame', @render, @

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

  playerLose: ->
    @$el.append('<div class="gameover lost">Oh noes! You lost. <div class="playAgain">Play again?</div></div>')

  playerWin: ->
    @$el.append('<div class="gameover won">Hell yeah, you won!<div class="playAgain">Play again?</div></div>')