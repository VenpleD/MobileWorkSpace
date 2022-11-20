//
//  MemoryGame.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/10/12.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>

    mutating func choose(card: Card) {
        let index = index(of: card);
        self.cards[index].isFaceUp = !self.cards[index].isFaceUp;
        print("card chosen: \(card)")
    }
    
    func index(of selectedCard: Card) -> Int {
        for index in 0..<self.cards.count {
            if selectedCard.id == self.cards[index].id {
                return index
            }
        }
        return 0
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(id: pairIndex * 2, content: content))
            cards.append(Card(id: pairIndex * 2 + 1, content: content))
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
    }
}
