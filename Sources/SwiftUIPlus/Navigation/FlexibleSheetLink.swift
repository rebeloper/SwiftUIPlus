//
//  FlexibleSheetLink.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public struct FlexibleSheetLink<Destination: View>: View {
    
    @Binding private var isActive: Bool
    private var flexibleSheetManager: FlexibleSheetManager
    private let swipesToDismiss: Bool
    private let ignoresSafeArea: Bool
    private let destination: () -> Destination
    private let onDismiss: () -> ()
    
    @State private var currentIsActive: Bool = false
    @State private var isDismissed: Bool = false
    
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
        Button(action: {}, label: {
            EmptyView()
        })
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
    }
    
}



