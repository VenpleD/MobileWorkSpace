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
    
    private var directory: URL?
    init(directory: URL) {
        self.name = directory.lastPathComponent
        self.directory = directory
        do {
            let documents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.isDirectoryKey])
            for document in documents {
                let emojiArtDocument = EmojiArtDocument(url: document)
                self.documentNames[emojiArtDocument] = document.lastPathComponent
            }
        } catch {
            print("load Docuemnts error in directory:\(directory) errorInfo: \(error.localizedDescription)")
        }

    }
    
    func name(for document: EmojiArtDocument) -> String {
        var nameString = ""
        if documentNames[document] == nil {
            documentNames[document] = "Untitled"
        }
        nameString = documentNames[document]!
        return nameString
    }
    
    func setName(_ name: String, for document: EmojiArtDocument) {
        if let documentUrl = directory?.appendingPathComponent(name, conformingTo: .data), !documentNames.values.contains(name) {
            removeDocument(document)
            document.url = documentUrl;
        }
        documentNames[document] = name;
    }
    
    var documents: [EmojiArtDocument] {
        documentNames.keys.sorted { documentNames[$0]! < documentNames[$1]! }
    }
    
    func addDocument(named name: String = "Untitled") {
        let uniquedName = name.uniqued(withRespectTo: documentNames.values)
        let documentUrl = directory?.appendingPathComponent(uniquedName, conformingTo: .data)
        let emojiArtDocument = EmojiArtDocument(url: documentUrl!)
        documentNames[emojiArtDocument] = uniquedName
    }
    
    func removeDocument(_ document: EmojiArtDocument) {
        if let name = documentNames[document], let url = directory?.appendingPathComponent(name, conformingTo: .data) {
            try? FileManager.default.removeItem(at: url)
        }
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
