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
    private var onSuccess: ((ImagePickerViewSuccessResult) -> ())?
    private var onFail: ((ImagePickerError) -> ())?
    
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
                onCancel: ((PHPickerViewController) -> ())? = nil,
                onFail: ((ImagePickerError) -> ())? = nil) {
        self._images = images
        self._results = .constant(nil)
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.onCancel = onCancel
        self.onSuccess = nil
        self.onFail = onFail
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
                onCancel: ((PHPickerViewController) -> ())? = nil,
                onFail: ((ImagePickerError) -> ())? = nil) {
        self._images = .constant(nil)
        self._results = results
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.onCancel = onCancel
        self.onSuccess = nil
        self.onFail = onFail
    }
    
    /// PHPickerViewController wrapper with `onSuccess` callback
    /// - Parameters:
    ///   - filter: filter
    ///   - selectionLimit: selection limit
    ///   - onCancel: callback representing when the PHPickerViewController was canceled
    ///   - onSuccess: callback representing when the PHPickerViewController has succeeded
    ///   - onFail: callback representing when the PHPickerViewController failed
    public init(filter: PHPickerFilter = .images,
                selectionLimit: Int = 1,
                onCancel: ((PHPickerViewController) -> ())? = nil,
                onSuccess: ((ImagePickerViewSuccessResult) -> ())? = nil,
                onFail: ((ImagePickerError) -> ())? = nil) {
        self._images = .constant(nil)
        self._results = .constant(nil)
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.onCancel = onCancel
        self.onSuccess = onSuccess
        self.onFail = onFail
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
        Coordinator(self, onCancel: onCancel, onSuccess: onSuccess, onFail: onFail)
    }
    
    public class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView

        init(_ parent: ImagePickerView, onCancel: ((PHPickerViewController) -> ())?, onSuccess: ((ImagePickerViewSuccessResult) -> ())?, onFail: ((ImagePickerError) -> ())?) {
            self.parent = parent
            self.onCancel = onCancel
            self.onSuccess = onSuccess
            self.onFail = onFail
        }
        
        private let onCancel: ((PHPickerViewController) -> ())?
        private let onSuccess: ((ImagePickerViewSuccessResult) -> ())?
        private let onFail: ((ImagePickerError) -> ())?
        
        public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if results.count == 0 {
                self.onCancel?(picker)
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            var images = [UIImage]()
            for i in 0..<results.count {
                let result = results[i]
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { newImage, error in
                        if let error = error {
                            self.onFail?(ImagePickerError(picker: picker, error: error))
                            self.parent.presentationMode.wrappedValue.dismiss()
                        } else if let image = newImage as? UIImage {
                            images.append(image)
                        }
                        if images.count == results.count {
                            if images.count != 0 {
                                self.parent.images = images
                                self.parent.results = results
                                let result = ImagePickerViewSuccessResult(images: images, results: results)
                                self.parent.onSuccess?(result)
                            } else {
                                self.onCancel?(picker)
                            }
                            self.parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                } else {
                    self.onFail?(ImagePickerError(picker: picker, error: ImagePickerViewError.cannotLoadObject))
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

public struct ImagePickerViewSuccessResult {
    public let images: [UIImage]
    public let results: [PHPickerResult]
}
