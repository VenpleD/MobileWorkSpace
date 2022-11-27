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
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        
                        viewModel.choose(card: card)
                    }
                }
                .padding(10)
            }
    //        .padding()
            .foregroundColor(Color.orange)
            Button {
                self.viewModel.resetGame()
                withAnimation(.easeOut) {
                }
            } label: {
                Text("New Game")
            }

        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimatin() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size:CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: -animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                startBonusTimeAnimatin()
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: -card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)

                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0)) /// 隐式动画，只有此声明是不能做动画的，需要下面的.animation
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .modifier(Cardify(isFaceUp: card.isFaceUp))
            .transition(AnyTransition.scale)
        }
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
