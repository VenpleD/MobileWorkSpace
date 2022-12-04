//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/12/2.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State var popoverStatus: Bool = false
    
    var body: some View {
        HStack {
            Stepper {
            } onIncrement: {
                self.chosenPalette = self.document.palette(after: self.chosenPalette)
            } onDecrement: {
                self.chosenPalette = self.document.palette(before: self.chosenPalette)
            }
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard")
                .onTapGesture {
                    self.popoverStatus = true
                }
                .popover(isPresented: $popoverStatus) {
                    PalettePopover(chosenPalette: $chosenPalette, popoverStatus: $popoverStatus).environmentObject(document)
                        .frame(minWidth: 200, minHeight: 300)
                }
        }
        .fixedSize()
    }
}


struct PalettePopover: View {
    
    @Binding var chosenPalette: String
    
    @Binding var popoverStatus: Bool
    
    @State private var paletteName: String = ""
    
    @State private  var inputEmojiString: String = ""
    
    @EnvironmentObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ZStack {
                Text("Palette Editter")
                HStack {
                    Spacer()
                    Button {
                        self.popoverStatus = false
                    } label: {
                        Text("Done")
                    }
                }
            }
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName) { begin in
                        if !begin {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    }
                    TextField("add emoji", text: $inputEmojiString) { begin in
                        if !begin {
                            self.chosenPalette = self.document.addEmoji(self.inputEmojiString, toPalette: self.chosenPalette)
                            self.inputEmojiString = ""
                        }
                    }
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(self.chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .onTapGesture {
                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                            }
                    }
                    .frame(height: self.height)
                }
            }
        }
        .onAppear {
            self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""
        }
    }
    
    var height: CGFloat {
        CGFloat(((chosenPalette.count - 1) / 6) * 70 + 70)
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
