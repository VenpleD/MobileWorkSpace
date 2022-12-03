//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Venple on 2022/11/27.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentChooser().environmentObject(EmojiArtDocumentStore())
        }
    }
    func createInitDocumentStore() -> EmojiArtDocumentStore {
        let emojiArtDocumentStore = EmojiArtDocumentStore()
        emojiArtDocumentStore.addDocument(named: "Hello Emoji")
        emojiArtDocumentStore.addDocument()
        return emojiArtDocumentStore
    }
}
