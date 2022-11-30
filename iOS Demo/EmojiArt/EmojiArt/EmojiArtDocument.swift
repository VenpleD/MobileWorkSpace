//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    static let palette: String = "😗😱🏐😗😱🏐🐶🐢⚽️"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: emojiArtKey)) ?? EmojiArt()
        fetchBackgroundImage()
    }
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            UserDefaults.standard.set(emojiArt.json(), forKey: emojiArtKey)
        }
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojiList: [EmojiArt.Emoji] { emojiArt.emojis }
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL;
        fetchBackgroundImage()
    }

    func fetchBackgroundImage() {
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)                            
                        }
                    }
                }
            }
        }
    }
    
    private let emojiArtKey = "EmojiArtDocumentl.emojiKey"
    
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var position: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
