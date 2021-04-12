//
//  FlexibleSheetManager.swift
//  
//
//  Created by Alex Nagy on 05.04.2021.
//

import SwiftUI

public class FlexibleSheetManager: ObservableObject {

    @Published public var isPresented: Bool = false
    public var sheet: () -> (AnyView) = { AnyView(Color.clear.frame(width: UIScreen.main.bounds.width)) }

    /// Shows a Flexible Sheet that has the height of its content
    /// - Parameters:
    ///   - sheet: the contents of the sheet
    public func show(_ sheet: @escaping () -> (AnyView)) {
        self.sheet = sheet
        withAnimation {
            isPresented = true
        }
    }

    /// Hides a Flexible Sheet
    public func hide() {
        withAnimation {
            isPresented = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.sheet = { AnyView(Color.clear.frame(width: UIScreen.main.bounds.width)) }
        }
    }

}

public extension View {
    /// Adds a Flexible Sheet to the view
    /// - Parameters:
    ///   - config: sheet configuration
    ///   - containerConfig: container configuration
    /// - Returns: a view that has the capability to show a Flexible Sheet
    func usesFlexibleSheetManager(config: FlexibleSheetConfig = FlexibleSheetConfig(), containerConfig: FlexibleSheetContainerConfig = FlexibleSheetContainerConfig()) -> some View {
        self.modifier(FlexibleSheetViewModifier(config: config, containerConfig: containerConfig)).usesStatusBarStyle()
    }
}
