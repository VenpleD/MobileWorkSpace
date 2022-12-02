//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/12/2.
//

import SwiftUI

struct PaletteChooser: View {
    var body: some View {
        HStack {
            Stepper {
            } onIncrement: {
                
            } onDecrement: {
                
            }
            Text("PaletteChooser");
        }
        .fixedSize()
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser()
    }
}
