//
//  Spinning.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/12/2.
//

import SwiftUI

struct Spinning: ViewModifier {
    
    @State private var isVisible: Bool = false
    
    private var degress: Double {
        isVisible ? 360 : 0
    }
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle.degrees(degress))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: degress)
            .onAppear {
                isVisible = true
            }
    }
}

extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
