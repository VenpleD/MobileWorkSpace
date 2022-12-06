//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Venple on 2022/12/3.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var documentStore: EmojiArtDocumentStore
    
    @State private var editMode: EditMode = .inactive
    
    @State private var navIsActive: Bool = false
    var body: some View {
        NavigationView {
            List {
                ForEach(documentStore.documents) { document in
                    NavigationLink {
                        EmojiArtDocumentView(document: document)
                            .navigationTitle(self.documentStore.name(for: document))
                    } label: {
                        EditableText(self.documentStore.name(for: document), isEditing: self.editMode.isEditing) { name in
                            self.documentStore.setName(name, for: document)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.map{ self.documentStore.documents[$0] }.forEach { document in
                        self.documentStore.removeDocument(document)
                    }
                }
            }
            .navigationTitle(documentStore.name)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "plus")
                        .onTapGesture {
                            self.documentStore.addDocument(named: "Untitled")
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            })
            .environment(\.editMode, $editMode)
        }
    }
}

//struct EmojiArtDocumentChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentChooser()
//    }
//}
