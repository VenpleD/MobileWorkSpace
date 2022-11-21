//
//  ContentView.swift
//  CS193p
//
//  Created by wenpu.duan on 2022/10/11.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                viewModel.choose(card: card)
            }
            .padding(10)
        }
//        .padding()
        .foregroundColor(Color.orange)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    private func body(for size:CGSize) -> some View {
        ZStack{
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Circle().padding(5).opacity(0.4)
                Text(card.content)
            } else {
                if (!card.isMatched) {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    private let cornerRadius: CGFloat = 10;
    private let edgeLineWidth: CGFloat = 3;
    
    private func fontSize(for size:CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let emojiMemoryGame: EmojiMemoryGame = EmojiMemoryGame()
        emojiMemoryGame.choose(card: emojiMemoryGame.cards[0])
        return ContentView(viewModel: emojiMemoryGame)
    }
}
