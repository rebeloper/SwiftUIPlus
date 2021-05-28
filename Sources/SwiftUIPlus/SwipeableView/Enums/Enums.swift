//
//  Enums.swift
//  
//
//  Created by Alex Nagy on 28.05.2021.
//

import SwiftUI

public enum SwipeableViewViewState: CaseIterable {
    case left
    case right
    case center
}

public enum SwipeableViewOnChangeSwipe {
    case leftStarted
    case rightStarted
    case noChange
}

public enum SwipeableViewActionSide: CaseIterable {
    case left
    case right
}
