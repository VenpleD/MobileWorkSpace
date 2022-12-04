//
//  EmojiArtOptionalImageView.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/11/30.
//

import SwiftUI

struct EmojiArtOptionalImageView: View {
    var backgroundImage: UIImage?
    var body: some View {
        return Group {
            if backgroundImage != nil {
                Image(uiImage: backgroundImage!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

