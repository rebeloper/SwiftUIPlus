//
//  SwipeableViewViewModel.swift
//  
//
//  Created by Alex Nagy on 28.05.2021.
//

import SwiftUI
import Combine

public class SwipeableViewViewModel: ObservableObject {
    
    let id: UUID = UUID.init()
    
    @Published var state: SwipeableViewViewState {
        didSet {
            if state != .center {
                self.stateDidChange.send(self)
            }
        }
    }
    
    @Published var onChangeSwipe: SwipeableViewOnChangeSwipe = .noChange
    @Published var dragOffset: CGSize
    
    let stateDidChange = PassthroughSubject<SwipeableViewViewModel, Never>()
    let otherActionTapped = PassthroughSubject<Bool, Never>()
    
    init(state: SwipeableViewViewState, size: CGSize) {
        self.state = state
        self.dragOffset = size
    }
    
    public func otherTapped(){
        self.otherActionTapped.send(true)
    }
    
    public func goToCenter(){
        self.dragOffset = .zero
        self.state = .center
        self.onChangeSwipe = .noChange
    }
}

