describe 'deck', ->
  deck = null
  hand = null

  beforeEach ->
    deck = new Deck()
    hand = deck.dealPlayer()

  describe 'hit', ->
    it "should give the last card from the deck", ->
      expect(deck.length).toBe 50
      hand.hit()
      #expect(deck.last()).toEqual hand.hit()
      expect(deck.length).toBe 49
      hand.hit()
      #expect(deck.last()).toEqual hand.hit()
      expect(deck.length).toBe 48
