//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    static let palette: String = "😗😱🏐🐶🐢⚽️"
    
    let id: UUID

    @Published var steadyZoomScale: CGFloat = 1.0
    
    @Published var steadyDragOffset: CGSize = .zero
    
    private var emojiArtCancelable: Cancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultKey)) ?? EmojiArt()
        emojiArtCancelable = $emojiArt.sink(receiveValue: { emojiArt in
            UserDefaults.standard.set(emojiArt.json(), forKey: defaultKey)
        })
        fetchBackgroundImage()
    }
    
    var url: URL? {
        didSet{ save(emojiArt) }
    }
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
        emojiArt = EmojiArt(json: try? Data(contentsOf: url)) ?? EmojiArt()
        emojiArtCancelable = $emojiArt.sink(receiveValue: { emojiArt in
            self.save(emojiArt)
        })
    }
    
    private func save(_ emoji: EmojiArt) {
        try? emojiArt.json()?.write(to: url!)
    }
    
    @Published private var emojiArt: EmojiArt
    
    @Published private(set) var backgroundImage: UIImage?
    
    private var fetchBackgroundUrl: Cancellable?
    
    var backgroundURL: URL? {
        get { emojiArt.backgroundURL }
        set {
            emojiArt.backgroundURL = newValue
            fetchBackgroundImage()
        }
    }
    
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

    func fetchBackgroundImage() {
        if let url = emojiArt.backgroundURL {
            fetchBackgroundUrl?.cancel()
            fetchBackgroundUrl = URLSession.shared
                .dataTaskPublisher(for: url)
                .map{ data, urlResponse in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { image in
                    self.backgroundImage = image
                }
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        if url == self.emojiArt.backgroundURL {
//                            self.backgroundImage = UIImage(data: imageData)
//                        }
//                    }
//                }
//            }
        }
    }

    
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var position: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
