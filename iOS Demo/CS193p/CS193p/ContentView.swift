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
        HStack{
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    viewModel.choose(card: card)
                }
            }
        }
        .padding()
        .foregroundColor(Color.orange)
        .font(Font.largeTitle)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    func body(for size:CGSize) -> some View {
        ZStack{
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    let cornerRadius: CGFloat = 10;
    let edgeLineWidth: CGFloat = 3;
    
    func fontSize(for size:CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
