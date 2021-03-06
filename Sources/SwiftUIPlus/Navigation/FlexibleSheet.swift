//
//  FlexibleSheet.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

public struct FlexibleSheet<Destination: View, Label: View>: View {
    
    @ObservedObject private var flexibleSheetManager: FlexibleSheetManager
    private let swipesToDismiss: Bool
    private let ignoresSafeArea: Bool
    private let destination: () -> Destination
    private let onDismiss: () -> ()
    private let label: () -> Label
    
    /// Button that presents a sheet.
    /// - Parameters:
    ///   - flexibleSheetManager: a @StateObject FlexibleSheetManager
    ///   - swipesToDismiss: Should the sheet be able to be dismissed with a swipe.
    ///   - ignoresSafeArea: Should the sheet content ignore the safe area.
    ///   - destination: A closure returning the content of the sheet.
    ///   - onDismiss: A closure executed when the sheet dismisses.
    ///   - label: A view that is embeded into a Button.
    public init(flexibleSheetManager: ObservedObject<FlexibleSheetManager>,
                swipesToDismiss: Bool = true,
                ignoresSafeArea: Bool = false,
                destination: @escaping () -> Destination,
                onDismiss: @escaping () -> () = {},
                label: @escaping () -> Label) {
        self._flexibleSheetManager = flexibleSheetManager
        self.swipesToDismiss = swipesToDismiss
        self.ignoresSafeArea = ignoresSafeArea
        self.destination = destination
        self.onDismiss = onDismiss
        self.label = label
    }
    
    public var body: some View {
        Button {
            flexibleSheetManager.present(destination: {
                destination().anyView()
            }, onDismiss: {
                onDismiss()
            }, config: flexibleSheetManager.config)
        } label: {
            label()
        }
    }
}


