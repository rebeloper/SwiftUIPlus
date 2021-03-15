//
//  FlexibleSheet.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public extension FlexibleSheet where Label == EmptyView {
    
    /// `EmptyView` with `isActive` `Binding<Bool>` that presents a `Destination` view when `isActive` is set to `true`.
    /// - Parameters:
    ///   - type: The page type presented. Default is .push.
    ///   - isActive: A binding string whether the destination is presented.
    ///   - destination: A closure returning the content of the destination.
    ///   - onDismiss: A closure executed when the navigation dismisses the presented view.
    init(_ flexibleSheetManager: FlexibleSheetManager,
         isActive: Binding<Bool>,
         destination: @escaping () -> Destination,
         onDismiss: @escaping () -> () = {}) {
        self.flexibleSheetManager = flexibleSheetManager
        self.flexibleSheetStyle = .emptyView
        self._isActiveBinding = isActive
        self.destination = destination
        self.label = { EmptyView() }
        self.onDismiss = onDismiss
    }
}

public struct FlexibleSheet<Destination: View, Label: View>: View {
    
    @State private var isActive = false
    @State private var currentIsActive: Bool = false
    
    private var flexibleSheetManager: FlexibleSheetManager
    private var flexibleSheetStyle: FlexibleSheetStyle
    @Binding private var isActiveBinding: Bool
    private let destination: () -> Destination
    private let label: () -> Label
    private let onDismiss: () -> ()
    
    public init(_ flexibleSheetManager: FlexibleSheetManager,
                style: FlexibleSheetStyle = .button,
                destination: @escaping () -> Destination,
                label: @escaping () -> Label,
                onDismiss: @escaping () -> () = {}) {
        self.flexibleSheetManager = flexibleSheetManager
        self.flexibleSheetStyle = style
        self._isActiveBinding = .constant(false)
        self.destination = destination
        self.label = label
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        VStack {
            switch flexibleSheetStyle {
            case .button:
                Button {
                    flexibleSheetManager.present(destination: {
                        destination().anyView()
                    }, onDismiss: {
                        onDismiss()
                    }, config: flexibleSheetManager.config)
                } label: {
                    label()
                }
            case .view:
                label()
                    .onTapGesture {
                        isActive.toggle()
                    }
                    .onReceive([isActive].publisher, perform: { isActive in
                        if currentIsActive == isActive { return }
                        currentIsActive = isActive
                        if isActive {
                            flexibleSheetManager.present(destination: {
                                destination().anyView()
                            }, onDismiss: {
                                currentIsActive = false
                                onDismiss()
                            }, config: flexibleSheetManager.config)
                        } else {
                            flexibleSheetManager.dismiss()
                        }
                    })
                    .onReceive(flexibleSheetManager.$isActive) { (isActive) in
                        if !isActive {
                            self.isActive = isActive
                        }
                    }
            case .emptyView:
                Button(action: {}, label: {
                    EmptyView()
                })
                .onReceive([isActiveBinding].publisher, perform: { isActive in
                    if currentIsActive == isActive { return }
                    currentIsActive = isActive
                    if isActive {
                        flexibleSheetManager.present(destination: {
                            destination().anyView()
                        }, onDismiss: {
                            currentIsActive = false
                            onDismiss()
                        }, config: flexibleSheetManager.config)
                    } else {
                        flexibleSheetManager.dismiss()
                    }
                })
                .onReceive(flexibleSheetManager.$isActive) { (isActive) in
                    if !isActive {
                        self.isActiveBinding = isActive
                    }
                }
            }
        }
        
    }
}

public enum FlexibleSheetStyle {
    case button
    case view
    case emptyView
}


