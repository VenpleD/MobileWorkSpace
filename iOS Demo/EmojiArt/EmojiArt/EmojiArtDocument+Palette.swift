//
//  EmojiArtDocument+Palette.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/12/2.
//

import Foundation

extension EmojiArtDocument {
    private static let palettesKey = "EmojiArtDocument.PalettesKey"
    
    
    private(set) var paletteNames: [String:String] {
        get {
            UserDefaults.standard.object(forKey: EmojiArtDocument.palettesKey) as? [String:String] ?? [
                "😀😅😂😇🥰😉🙃😎🥳😡🤯🥶🤥😴🙄👿😷🤧🤡": "Faces",
                "🍏🍎🥒🍞🥨🥓🍔🍟🍕🍰🍿☕️": "Food",
                "🐶🐼🐵🙈🙉🙊🦆🐝🕷🐟🦓🐪🦒🦨": "Animals",
                "⚽️🏈⚾️🎾🏐🏓⛳️🥌⛷🚴‍♂️🎳🎼🎭🪂": "Activities"
            ]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: EmojiArtDocument.palettesKey)
            objectWillChange.send()
        }
    }
    
    var sortedPalettes: [String] {
        paletteNames.keys.sorted(by: { paletteNames[$0]! < paletteNames[$1]! })
    }
    
    var defaultPalettes: String {
        sortedPalettes.first ?? "⚠️"
    }
    
    func renamePalette(_ palette: String, to name: String) {
        paletteNames[palette] = name
    }
    
    func addPalette(_ palette: String, named name: String) {
        paletteNames[name] = palette
    }
    
    func removePalette(named name: String) {
        paletteNames[name] = nil
    }
    
    @discardableResult
    func addEmoji(_ emoji: String, toPalette palette: String) -> String {
        return changePalette(palette, to: (emoji + palette).uniqued())
    }
    
    @discardableResult
    func removeEmoji(_ emojiToRemove: String, fromPalette palette: String) -> String {
        return changePalette(palette, to: palette.filter({ !emojiToRemove.contains($0) }))
    }
    
    private func changePalette(_ palette: String, to newPalette: String) -> String {
        let name = paletteNames[palette] ?? ""
        paletteNames[palette] = nil
        paletteNames[newPalette] = name
        return newPalette
    }
}
