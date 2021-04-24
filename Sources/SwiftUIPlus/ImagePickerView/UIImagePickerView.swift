//
//  UIImagePickerView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI
import UIKit

public struct UIImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding private var image: UIImage?
    @Binding private var info: [UIImagePickerController.InfoKey : Any]?
    private let allowsEditing: Bool
    private let sourceType: UIImagePickerController.SourceType
    private var didCancel: ((UIImagePickerController) -> ())?
    
    /// UIImagePickerController wrapper with `image` binding
    /// - Parameters:
    ///   - image: image
    ///   - allowsEditing: allows editing
    ///   - sourceType: source type
    ///   - didCancel: callback representing when the UIImagePickerController was canceled
    public init(image: Binding<UIImage?>,
                allowsEditing: Bool = true,
                sourceType: UIImagePickerController.SourceType = .photoLibrary,
                didCancel: ((UIImagePickerController) -> ())? = nil) {
        self._image = image
        self._info = .constant(nil)
        self.allowsEditing = allowsEditing
        self.sourceType = sourceType
        self.didCancel = didCancel
    }
    
    /// UIImagePickerController wrapper with `info` binding
    /// - Parameters:
    ///   - info: info
    ///   - allowsEditing: allows editing
    ///   - sourceType: source type
    ///   - didCancel: callback representing when the UIImagePickerController was canceled
    public init(info: Binding<[UIImagePickerController.InfoKey : Any]?>,
                allowsEditing: Bool = true,
                sourceType: UIImagePickerController.SourceType = .photoLibrary,
                didCancel: ((UIImagePickerController) -> ())? = nil) {
        self._image = .constant(nil)
        self._info = info
        self.allowsEditing = allowsEditing
        self.sourceType = sourceType
        self.didCancel = didCancel
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<UIImagePickerView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = allowsEditing
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<UIImagePickerView>) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, didCancel: didCancel)
    }
    
    public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: UIImagePickerView

        init(_ parent: UIImagePickerView, didCancel: ((UIImagePickerController) -> ())?) {
            self.parent = parent
            self.didCancel = didCancel
        }
        
        private let didCancel: ((UIImagePickerController) -> ())?
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            var image = UIImage()
            if let editedImage = info[.editedImage] as? UIImage {
                image = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                image = originalImage
            }
            parent.image = image
            parent.info = info
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            didCancel?(picker)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
