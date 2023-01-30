//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Venple on 2022/12/3.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var documentStore: EmojiArtDocumentStore
    
//    var selectionId: Binding<Array<EmojiArtDocument.ID>>? {
//        Binding {
//            documentStore.documents.map{ $0.id }
//        } set: { value in
//            for id in value {
//
//            }
//        }
//
//    }
    
    @State private var selectionDocument: EmojiArtDocument?
    
    @State private var editMode: EditMode = .inactive
    
    @State private var navIsActive: Bool = false
    var body: some View {
        NavigationSplitView {
            List(documentStore.documents, selection: $selectionDocument) { document in
                NavigationLink(value: document ){
                    EditableText(self.documentStore.name(for: document), isEditing: self.editMode.isEditing) { name in
                        self.documentStore.setName(name, for: document)
                    }
                }
            }
//            List(documentStore.documents, id: \.id) { document in
//
//            }
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
        } detail: {
            EmojiArtDocumentView(document: selectionDocument ?? EmojiArtDocument())
        }

        
//        NavigationStack {
//            List {
//                ForEach(documentStore.documents) { document in
//                    NavigationLink {
//                        EmojiArtDocumentView(document: document)
//                            .navigationTitle(self.documentStore.name(for: document))
//                    } label: {
//                        EditableText(self.documentStore.name(for: document), isEditing: self.editMode.isEditing) { name in
//                            self.documentStore.setName(name, for: document)
//                        }
//                    }
//                }
//                .onDelete { indexSet in
//                    indexSet.map{ self.documentStore.documents[$0] }.forEach { document in
//                        self.documentStore.removeDocument(document)
//                    }
//                }
//            }
//            .navigationTitle(documentStore.name)
//            .toolbar(content: {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Image(systemName: "plus")
//                        .onTapGesture {
//                            self.documentStore.addDocument(named: "Untitled")
//                        }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//            })
//            .environment(\.editMode, $editMode)
//        }
    }
}

//struct EmojiArtDocumentChooser_Previews: PreviewProvider {
//    static var previews: some View {
//        EmojiArtDocumentChooser()
//    }
//}
