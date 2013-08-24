describe 'hand', ->
  myHand = null

  describe 'scoring', ->
    it "should add scores of two cards together", ->
      card1 = new Card
                    rank: 5
                    suit: 2
      card2 = new Card
                    rank: 6
                    suit: 2

      myHand = new Hand([card1, card2])

      expect(myHand.scores().toString()).toBe '11'
      expect(myHand.bestScore()).toBe 11

    it "should handle aces", ->
      card1 = new Card
                    rank: 1
                    suit: 2
      card2 = new Card
                    rank: 6
                    suit: 2

      myHand = new Hand([card1, card2])

      expect(myHand.scores().toString()).toBe '7,17'
      expect(myHand.bestScore()).toBe 17

    it "should not give a bestScore above 21", ->
      card1 = new Card
                    rank: 1
                    suit: 2
      card2 = new Card
                    rank: 6
                    suit: 2
      card3 = new Card
                    rank: 10
                    suit: 2

      myHand = new Hand([card1, card2, card3])

      expect(myHand.scores().toString()).toBe '17,27'
      expect(myHand.bestScore()).toBe 17

    it "should respect the privacy of fliped cards when scoring", ->
      card2 = new Card
                    rank: 6
                    suit: 2
      card3 = new Card
                    rank: 10
                    suit: 2

      myHand = new Hand([card2, card3.flip()])

      expect(myHand.scores().toString()).toBe '6'
      expect(myHand.bestScore()).toBe 6






































