//
//  MailView.swift
//  
//
//  Created by Alex Nagy on 02.06.2021.
//

import SwiftUI
import MessageUI

public struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    public var configure: ((MFMailComposeViewController) -> Void)?
    public var onFinish: ((MFMailComposeResult) -> ())?
    public var onFail: ((Error) -> ())?
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        let parent: MailView
        @Binding var presentation: PresentationMode
        var onFinish: ((MFMailComposeResult) -> ())?
        var onFail: ((Error) -> ())?
        
        init(_ parent: MailView, presentation: Binding<PresentationMode>,
             onFinish: ((MFMailComposeResult) -> ())?,
             onFail: ((Error) -> ())?) {
            self.parent = parent
            _presentation = presentation
            self.onFinish = onFinish
            self.onFail = onFail
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.parent.onFail?(error!)
                }
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.parent.onFinish?(result)
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self, presentation: presentationMode, onFinish: onFinish, onFail: onFail)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        configure?(viewController)
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) { }
}
