//
//  EmojiMemoryGame.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/10/12.
//

import SwiftUI


protocol Greatness {
    func isGreaterThan(other: Self) -> Bool
    /// 这里的Self指的是实现该协议的（任何事物）的类型
}


class EmojiMemoryGame: ObservableObject {
    private(set) var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃", "🕷️"]
        return MemoryGame(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}
