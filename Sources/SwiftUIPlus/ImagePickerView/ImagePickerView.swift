//
//  ImagePickerView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI
import UIKit
import PhotosUI

public struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding private var images: [UIImage]?
    @Binding private var results: [PHPickerResult]?
    private let filter: PHPickerFilter
    private let selectionLimit: Int
    private var onCancel: ((PHPickerViewController) -> ())?
    private let onFail: ((ImagePickerError) -> ())?
    
    /// PHPickerViewController wrapper with `images` binding
    /// - Parameters:
    ///   - images: binded images
    ///   - filter: filter
    ///   - selectionLimit: selection limit
    ///   - onCancel: callback representing when the PHPickerViewController was canceled
    ///   - onFail: callback representing when the PHPickerViewController failed
    public init(images: Binding<[UIImage]?>,
                filter: PHPickerFilter = .images,
                selectionLimit: Int = 1,
                didCancel: ((PHPickerViewController) -> ())? = nil,
                didFail: ((ImagePickerError) -> ())? = nil) {
        self._images = images
        self._results = .constant(nil)
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.onCancel = didCancel
        self.onFail = didFail
    }
    
    /// PHPickerViewController wrapper with `results` binding
    /// - Parameters:
    ///   - results: binded results
    ///   - filter: filter
    ///   - selectionLimit: selection limit
    ///   - onCancel: callback representing when the PHPickerViewController was canceled
    ///   - onFail: callback representing when the PHPickerViewController failed
    public init(results: Binding<[PHPickerResult]?>,
                filter: PHPickerFilter = .images,
                selectionLimit: Int = 1,
                didCancel: ((PHPickerViewController) -> ())? = nil,
                didFail: ((ImagePickerError) -> ())? = nil) {
        self._images = .constant(nil)
        self._results = results
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.onCancel = didCancel
        self.onFail = didFail
    }
    
    public func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = filter
        configuration.selectionLimit = selectionLimit
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self, didCancel: onCancel, didFail: onFail)
    }
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView, didCancel: ((PHPickerViewController) -> ())?, didFail: ((ImagePickerError) -> ())?) {
            self.parent = parent
            self.didCancel = didCancel
            self.didFail = didFail
        }
        
        private let didCancel: ((PHPickerViewController) -> ())?
        private let didFail: ((ImagePickerError) -> ())?
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.count == 0 {
                self.didCancel?(picker)
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            var images = [UIImage]()
            for i in 0..<results.count {
                let result = results[i]
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
                        if let error = error {
                            self.didFail?(ImagePickerError(picker: picker, error: error))
                            self.parent.presentationMode.wrappedValue.dismiss()
                        } else if let image = newImage as? UIImage {
                            images.append(image)
                        }
                        if images.count == results.count {
                            if images.count != 0 {
                                self.parent.images = images
                                self.parent.results = results
                            } else {
                                self.didCancel?(picker)
                            }
                            self.parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    self.didFail?(ImagePickerError(picker: picker, error: ImagePickerViewError.cannotLoadObject))
                    parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

public struct ImagePickerError {
    public let picker: PHPickerViewController
    public let error: Error
}

public enum ImagePickerViewError: Error {
    case cannotLoadObject
    case failedToLoadObject
}
