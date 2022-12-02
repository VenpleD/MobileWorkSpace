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
                            .scaleEffect(self.zoomScale)
                            .offset(self.dragOffset)
                    )
                    if !isLoading {
                        ForEach(self.document.emojiList) { emoji in
                            Text(emoji.text)
                                .font(animatableSize: emoji.fontSize * zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                        }
                    } else {
                        Image(systemName: "hourglass").imageScale(.large).spinning()
                    }
                }
                .clipped()
                .edgesIgnoringSafeArea([.horizontal, .bottom])                
            /// 第一个参数，是你想要拖拽的是什么，这里我们想要拖拽的是public.image，这里"public.image"是一个URI，它规定了这些内容类型的公共协议，这些内容都是image，我们需要URL，那么拖拽的提供者是可以给出URL的
            /// 第二个参数是绑定参数  ，这个参数大概是说，当我们拖过来的时候，不是他们掉下来的时候，而是拖过来的时候
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var convertLocation = location 
                    convertLocation = CGPoint(x: convertLocation.x - geometry.size.width/2, y:convertLocation.y - geometry.size.height/2)
                    convertLocation = CGPoint(x: convertLocation.x - dragOffset.width, y: convertLocation.y - dragOffset.height)
                    convertLocation = CGPoint(x: convertLocation.x / zoomScale, y: convertLocation.y / zoomScale)
                    return self.drop(providers: providers, at: convertLocation)
                }
                .gesture(dragGestureFunc())
                .gesture(doubleTap(in: geometry.size))
                .gesture(magnificationGestureFunc())
            }
        }
    }
    
    private var isLoading: Bool {
        document.backgroundImage == nil && (document.backgroundURL != nil)
    }
    
    @State private var steadyZoomScale: CGFloat = 1.0
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    @State private var steadyDragOffset: CGSize = .zero
    
    @GestureState private var dragGestureOffset: CGSize = .zero
    
    private var zoomScale: CGFloat {
        steadyZoomScale * gestureZoomScale
    }
    
    private var dragOffset: CGSize {
        (steadyDragOffset + dragGestureOffset) * zoomScale
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if image != nil, let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.steadyZoomScale = min(hZoom, vZoom)
            self.steadyDragOffset = CGSizeZero
        }
    }
    
    private func magnificationGestureFunc() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { magnificationScale, gestureZoomScale, transcation in
                gestureZoomScale = magnificationScale
            }
            .onEnded() { magnificationScale in
                steadyZoomScale *= magnificationScale
            }
    }
    
    private func doubleTap(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded { scale in
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)                    
                }
            }
    }
    
    private func dragGestureFunc() -> some Gesture {
        DragGesture()
            .updating($dragGestureOffset) {lastDragOffset, dragGestureOffset, transaction in
                dragGestureOffset = lastDragOffset.translation / zoomScale
            }
            .onEnded { finalDragOffset in
                self.steadyDragOffset = self.steadyDragOffset + (finalDragOffset.translation / zoomScale)
            }
    }
    
//    private func font(for emoji: EmojiArt.Emoji) -> Font {
//        Font.system(size: emoji.fontSize * zoomScale)
//    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var position = CGPoint(x: emoji.position.x * zoomScale, y: emoji.position.y * zoomScale)
        position = CGPoint(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
        position = CGPoint(x: position.x + size.width / 2, y: position.y + size.height / 2)
        return position
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        // 当参数是要传类型变量的时候，需要加".self"，他是类型中的一个静态变量，返回类型本身，这种方式，对实例对象有效，对类也有效
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.backgroundURL = url
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


