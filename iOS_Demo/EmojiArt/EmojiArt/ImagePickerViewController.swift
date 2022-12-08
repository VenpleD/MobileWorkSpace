//
//  ImagePickerView.swift
//  EmojiArt
//
//  Created by wenpu.duan on 2022/12/8.
//

import SwiftUI
import UIKit

typealias SelectedImageCallBack = (_ imageUrl: URL?) -> Void

struct ImagePickerViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    typealias Coordinator = CoordinatorObj
    
    var selectedImage: SelectedImageCallBack?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.delegate = context.coordinator
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> CoordinatorObj {
        return CoordinatorObj(selectedImage: selectedImage)
    }
    
    class CoordinatorObj: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var selectedImage: SelectedImageCallBack?
        
        init(selectedImage: SelectedImageCallBack?) {
            self.selectedImage = selectedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if self.selectedImage != nil {
                self.selectedImage!(info[.imageURL] as? URL)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            if self.selectedImage != nil {
                self.selectedImage!(nil)
            }
        }
    }
    
}
