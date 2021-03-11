////
////  Page.swift
////  
////
////  Created by Alex Nagy on 10.03.2021.
////
//
//import SwiftUI
//
//public struct Page<Destination: View, Label: View>: View {
//    
//    @State private var isActive = false
//    
//    private var pageStyle: PageStyle
//    private var pageType: PageType
//    private let destination: () -> Destination
//    private let label: () -> Label
//    private let onDismiss: (() -> Void)?
//    
//    /// Controls a navigation presentation when a given condition is true.
//    /// - Parameters:
//    ///   - style: The style of the view that triggers the page. Default is .button.
//    ///   - type: The page type presented. Default is .push.
//    ///   - destination: A closure returning the content of the destination.
//    ///   - label: A view that is embeded into a NavigationLink.
//    ///   - onDismiss: A closure executed when the push dismisses.
//    public init(_ style: PageStyle = .button,
//                type: PageType = .push,
//                isActive: Binding<Bool>,
//                destination: @escaping () -> Destination,
//                label: @escaping () -> Label,
//                onDismiss: (() -> Void)? = nil) {
//        self.pageStyle = style
//        self.pageType = type
//        self.destination = destination
//        self.label = label
//        self.onDismiss = onDismiss
//    }
//    
//    public var body: some View {
//        VStack {
//            switch pageType {
//            case .push:
//                switch pageStyle {
//                case .button:
//                    NavigationLink(destination: destination().onDisappear(perform: {
//                        onDismiss?()
//                    })) {
//                        label()
//                    }
//                case .view:
//                    label().onTapGesture {
//                        isActive.toggle()
//                    }
//                    PageLink(.push, isActive: $isActive, destination: destination, onDismiss: onDismiss)
//                }
//                
//            case .sheet:
//                switch pageStyle {
//                case .button:
//                    Button {
//                        isActive.toggle()
//                    } label: {
//                        label()
//                    }
//                    .sheet(isPresented: $isActive, onDismiss: onDismiss) {
//                        destination()
//                    }
//                case .view:
//                    label().onTapGesture {
//                        isActive.toggle()
//                    }
//                    PageLink(.sheet, isActive: $isActive, destination: destination, onDismiss: onDismiss)
//                }
//                
//            case .fullScreenSheet:
//                switch pageStyle {
//                case .button:
//                    Button {
//                        isActive.toggle()
//                    } label: {
//                        label()
//                    }
//                    .fullScreenCover(isPresented: $isActive, onDismiss: onDismiss) {
//                        destination()
//                    }
//                case .view:
//                    label().onTapGesture {
//                        isActive.toggle()
//                    }
//                    PageLink(.fullScreenSheet, isActive: $isActive, destination: destination, onDismiss: onDismiss)
//                }
//                
//            }
//        }
//    }
//}
//
//public enum PageType {
//    case push
//    case sheet
//    case fullScreenSheet
//}
//
//public enum PageStyle {
//    case button
//    case view
//    case link
//}
