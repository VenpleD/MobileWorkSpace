//
//  MemoryGame.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/10/12.
//

import Foundation

struct MemoryGame<CardContent> {
    var cards: Array<Card>

    func choose(card: Card) {
        print("card chosen: \(card)")
    }
    
    struct Card {
        var isFaceUp: Bool
        var isMatched: Bool
        var content: CardContent
    }
}
