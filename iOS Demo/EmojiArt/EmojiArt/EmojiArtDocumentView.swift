//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map{ String($0) }, id:\.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                    }
                }
            }
            .padding(.horizontal)
            Rectangle().foregroundColor(Color.yellow)
                .edgesIgnoringSafeArea([.horizontal, .bottom])
            /// 第一个参数，是你想要拖拽的是什么，这里我们想要拖拽的是public.image，这里"public.image"是一个URI，它规定了这些内容类型的公共协议，这些内容都是image，我们需要URL，那么拖拽的提供者是可以给出URL的
            /// 第二个参数是绑定参数  ，这个参数大概是说，当我们拖过来的时候，不是他们掉下来的时候，而是拖过来的时候
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    return self.drop(providers: providers)
                }
        }
    }
    
    private func drop(providers: [NSItemProvider]) -> Bool {
        // 当参数是要传类型变量的时候，需要加".self"，他是类型中的一个静态变量，返回类型本身，这种方式，对实例对象有效，对类也有效
        let found = providers.loadFirstObject(ofType: URL.self) { url in
            print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}


