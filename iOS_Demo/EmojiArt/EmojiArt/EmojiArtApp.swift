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
            EmojiArtDocumentChooser().environmentObject(createInitDocumentStore())
        }
    }
    func createInitDocumentStore() -> EmojiArtDocumentStore {
        let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false);
        let emojiArtDocumentStore = EmojiArtDocumentStore(directory: url!)
        return emojiArtDocumentStore
    }
}
