//
//  SwipeableViewManager.swift
//  
//
//  Created by Alex Nagy on 28.05.2021.
//

import Combine

public class SwipeableViewManager: ObservableObject {
    
    private var viewModels: [SwipeableViewViewModel]
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        viewModels = []
    }
    
    public func hideAllViews() {
        self.viewModels.forEach {
            $0.goToCenter()
        }
    }
    
    public func addViewModel(_ viewModel: SwipeableViewViewModel) {
        viewModels.append(viewModel)
        viewModel.stateDidChange.sink(receiveValue: { vm in
            if self.viewModels.count != 0 {
                self.viewModels.forEach {
                    if vm.id != $0.id && $0.state != .center{
                        $0.goToCenter()
                    }
                }
            }
        }).store(in: &cancellables)
        
        viewModel.otherActionTapped.sink(receiveValue: { _ in
            if self.viewModels.count != 0 {
                self.viewModels.forEach {
                    $0.goToCenter()
                }
            }
        }).store(in: &cancellables)
    }
}

