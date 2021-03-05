//
//  FlexibleSheetView.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public struct FlexibleSheetView<Destination: View, Label: View>: View {
    
    @Binding private var isActive: Bool
    private let swipesToDismiss: Bool
    private let ignoresSafeArea: Bool
    private let destination: () -> Destination
    private let onDismiss: () -> ()
    private let label: () -> Label
    
    /// Button that presents a sheet.
    /// - Parameters:
    ///   - isActive: A binding to whether the sheet is presented.
    ///   - swipesToDismiss: Should the sheet be able to be dismissed with a swipe.
    ///   - ignoresSafeArea: Should the sheet content ignore the safe area.
    ///   - destination: A closure returning the content of the sheet.
    ///   - onDismiss: A closure executed when the sheet dismisses.
    ///   - label: A view that is embeded into a Button.
    public init(isActive: Binding<Bool>,
                swipesToDismiss: Bool = true,
                ignoresSafeArea: Bool = false,
                destination: @escaping () -> Destination,
                onDismiss: @escaping () -> () = {},
                label: @escaping () -> Label) {
        self._isActive = isActive
        self.swipesToDismiss = swipesToDismiss
        self.ignoresSafeArea = ignoresSafeArea
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        Button {
            isActive.toggle()
        } label: {
            label()
        }
        .flexibleSheet(isActive: $isActive, swipesToDismiss: swipesToDismiss, ignoresSafeArea: ignoresSafeArea) {
            destination()
        } onDismiss: {
            onDismiss()
        }
    }
}




