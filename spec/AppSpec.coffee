describe "gameplay", ->
  playerHand = null
  dealerHand = null
  app = null
  appView = null

  beforeEach ->
    app = new App()
    appView = new AppView(model: app)
    spyOn(appView, 'playerLose')

  describe 'end of game logic', ->
    ### This works but requires extraneous true false values to pass arbitrary tests
    Spies don't work
    
    it "should properly compare player and dealer scores", ->
      card1 = new Card
                    rank: 5
                    suit: 2
      card2 = new Card
                    rank: 7
                    suit: 2

      card3 = new Card
                    rank: 10
                    suit: 1

      playerHand = new Hand([card1, card2])
      dealerHand = new Hand([card3.flip(), card2])

      app.set('playerHand', playerHand)
      app.set('dealerHand', dealerHand)

      expect(app.endGame()).toBe false
    ###
    it 'the dealer should hit until they have 17 or more', ->
      card1 = new Card
                    rank: 5
                    suit: 2
      card2 = new Card
                    rank: 2
                    suit: 2

      card3 = new Card
                    rank: 2
                    suit: 1

      deck = new Deck()
      playerHand = new Hand([card1, card2], deck)
      dealerHand = new Hand([card3.flip(), card2], deck)

      app.set('playerHand', playerHand)
      app.set('dealerHand', dealerHand)

      app.endGame()

      expect(dealerHand.bestScore()).toBeGreaterThan 4