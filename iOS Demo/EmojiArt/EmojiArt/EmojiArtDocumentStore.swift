//
//  EmojiArtDocumentStore.swift
//  EmojiArt
//
//  Created by Venple on 2022/12/3.
//

import SwiftUI
import Combine

class EmojiArtDocumentStore: ObservableObject {
    let name: String
    
    @Published var documentNames = [EmojiArtDocument:String]()
    
    private var autosave: AnyCancellable?
    
    init(named name: String = "Emoji Art") {
        self.name = name
        let defaultKey = "EmojiArtDocumentStore.\(name)"
        documentNames = Dictionary(fromPropertyList: UserDefaults.standard.object(forKey: defaultKey))
        autosave = $documentNames.sink(receiveValue: { names in
            UserDefaults.standard.set(names.asPropertyList, forKey: defaultKey)
        })
    }
    
    func name(for document: EmojiArtDocument) -> String {
        if documentNames[document] == nil {
            documentNames[document] = "Untitled"
        }
        return documentNames[document]!
    }
    
    func setName(_ name: String, for document: EmojiArtDocument) {
        documentNames[document] = name
    }
    
    var documents: [EmojiArtDocument] {
        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
    }
    
    func addDocument(named name: String = "Untitled") {
        documentNames[EmojiArtDocument()] = name
    }
    
    func removeDocument(_ document: EmojiArtDocument) {
        documentNames[document] = nil
    }
    

}

extension Dictionary where Key == EmojiArtDocument, Value == String {
    var asPropertyList: [String:String] {
        var uuidToName = [String:String]()
        for (key, value) in self {
            uuidToName[key.id.uuidString] = value
        }
        return uuidToName
    }
    
    init(fromPropertyList plist: Any?) {
        self.init()
        let uuidToName = plist as? [String:String] ?? [:]
        for uuid in uuidToName.keys {
            self[EmojiArtDocument(id: UUID(uuidString: uuid))] = uuidToName[uuid]
        }
    }
}
