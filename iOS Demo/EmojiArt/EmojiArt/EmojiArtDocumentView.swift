//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map{ String($0) }, id:\.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag {
                                NSItemProvider(object: emoji as NSString)
                            }
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        EmojiArtOptionalImageView(backgroundImage: document.backgroundImage)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                    )
                    ForEach(self.document.emojiList) { emoji in
                        Text(emoji.text)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])                
            /// 第一个参数，是你想要拖拽的是什么，这里我们想要拖拽的是public.image，这里"public.image"是一个URI，它规定了这些内容类型的公共协议，这些内容都是image，我们需要URL，那么拖拽的提供者是可以给出URL的
            /// 第二个参数是绑定参数  ，这个参数大概是说，当我们拖过来的时候，不是他们掉下来的时候，而是拖过来的时候
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var convertLocation = location
                    convertLocation = CGPoint(x: convertLocation.x - geometry.size.width/2, y:convertLocation.y - geometry.size.height/2)
                    return self.drop(providers: providers, at: convertLocation)
                }
                .gesture(doubleTap())
            }
        }
    }
    
    @State private var zoomScale: CGFloat = 1.0
    
    private func doubleTap() -> some Gesture {
        TapGesture(count: 2)
            .onEnded { scale in
                zoomScale = 1.0
            }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        CGPoint(x: emoji.position.x + size.width / 2, y: emoji.position.y + size.height / 2)
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        // 当参数是要传类型变量的时候，需要加".self"，他是类型中的一个静态变量，返回类型本身，这种方式，对实例对象有效，对类也有效
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        if (!found) {
            found = providers.loadObjects(ofType: String.self, using: { string in
                self.document.addEmoji(string, at: location, size: defaultEmojiSize)
            })
        }

        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}


