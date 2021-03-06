//
//  FlexibleSheetLink.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public struct FlexibleSheetLink<Destination: View, Label: View>: View {
    
    @Binding private var isActive: Bool
    private var flexibleSheetManager: FlexibleSheetManager
    private let swipesToDismiss: Bool
    private let ignoresSafeArea: Bool
    private let destination: () -> Destination
    private let onDismiss: () -> ()
    
    /// Button that presents a sheet.
    /// - Parameters:
    ///   - isActive: A binding to whether the sheet is presented.
    ///   - flexibleSheetManager: a FlexibleSheetManager.
    ///   - swipesToDismiss: Should the sheet be able to be dismissed with a swipe.
    ///   - ignoresSafeArea: Should the sheet content ignore the safe area.
    ///   - destination: A closure returning the content of the sheet.
    ///   - onDismiss: A closure executed when the sheet dismisses.
    public init(isActive: Binding<Bool>,
                flexibleSheetManager: FlexibleSheetManager,
                swipesToDismiss: Bool = true,
                ignoresSafeArea: Bool = false,
                destination: @escaping () -> Destination,
                onDismiss: @escaping () -> () = {}) {
        self._isActive = isActive
        self.flexibleSheetManager = flexibleSheetManager
        self.swipesToDismiss = swipesToDismiss
        self.ignoresSafeArea = ignoresSafeArea
        self.destination = destination
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        Button {
            self.isActive.toggle()
            if isActive {
                flexibleSheetManager.present(destination: {
                    destination().anyView()
                }, onDismiss: {
                    onDismiss()
                }, config: flexibleSheetManager.config)
            }
        } label: {
            EmptyView()
        }
    }
}



