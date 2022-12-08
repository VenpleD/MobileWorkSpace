//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    @State var chosenPalette: String = ""
    
    @State var settingBgImageAlertStatue: Bool = false
    
    @State var noPastedContentAlertStatus: Bool = false
    
    @State var imagePickerStatue: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser(document: document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map{ String($0) }, id:\.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag {
                                    NSItemProvider(object: emoji as NSString)
                                }
                        }
                    }
                }
            }
            .onAppear {
                self.chosenPalette = self.document.defaultPalette
            }
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
                .onReceive(self.document.$backgroundImage, perform: { backgroundImage in
                    zoomToFit(backgroundImage, in: geometry.size)
                })
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
            .zIndex(-1)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    
                    Image(systemName: "photo").imageScale(.large)
                        .onTapGesture {
                            
                            self.imagePickerStatue = true
                        }
                        .sheet(isPresented: $imagePickerStatue, content: {
                            ImagePickerViewController { imageUrl in
                                self.document.backgroundURL = imageUrl
                                self.imagePickerStatue = false
                            }
                        })
                    Button {
                        if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                            self.settingBgImageAlertStatue = true
                        } else {
                            self.noPastedContentAlertStatus = true;
                        }
                    } label: {
                        Image(systemName: "doc.on.clipboard")
                            .alert("复制图片地址，点击此按钮以粘贴图片", isPresented: $noPastedContentAlertStatus) {
                                Button {
                                    self.noPastedContentAlertStatus = false
                                } label: {
                                    Text("OK")
                                }

                            }
                    }
                    .alert("是否要粘贴图片地址\(UIPasteboard.general.url?.absoluteString ?? "")", isPresented: $settingBgImageAlertStatue) {
                        HStack {
                            Button {
                                self.settingBgImageAlertStatue = false
                                self.document.backgroundURL = UIPasteboard.general.url
                            } label: {
                                Text("OK")
                            }
                            Button {
                                self.settingBgImageAlertStatue = false
                            } label: {
                                Text("Cancel")
                            }

                        }
                    }
                }

            }
        }
    }
    
    private var isLoading: Bool {
        document.backgroundImage == nil && (document.backgroundURL != nil)
    }
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    @GestureState private var dragGestureOffset: CGSize = .zero
    
    private var zoomScale: CGFloat {
        self.document.steadyZoomScale * gestureZoomScale
    }
    
    private var dragOffset: CGSize {
        (self.document.steadyDragOffset + dragGestureOffset) * zoomScale
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if image != nil, let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyZoomScale = min(hZoom, vZoom)
            self.document.steadyDragOffset = CGSizeZero
        }
    }
    
    private func magnificationGestureFunc() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { magnificationScale, gestureZoomScale, transcation in
                gestureZoomScale = magnificationScale
            }
            .onEnded() { magnificationScale in
                self.document.steadyZoomScale *= magnificationScale
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
                self.document.steadyDragOffset = self.document.steadyDragOffset + (finalDragOffset.translation / zoomScale)
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


