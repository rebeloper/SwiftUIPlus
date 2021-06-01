//
//  SwipeableView.swift
//  
//
//  Created by Alex Nagy on 28.05.2021.
//

import SwiftUI

public struct SwipeableView<Content: View>: View {
    
    @ObservedObject var viewModel: SwipeableViewViewModel
    var manager: SwipeableViewManager
    
    var rightActions: SwipeableViewActionsViewModel
    var leftActions: SwipeableViewActionsViewModel
    var rounded: Bool
    let content: Content
    
    @State var finishedOffset: CGSize = .zero
    
    public init(rightActions: [SwipeableViewAction],
                leftActions: [SwipeableViewAction] = [],
                rounded: Bool = false,
                @ViewBuilder content: () -> Content) {
        
        self.content = content()
        self.rightActions = SwipeableViewActionsViewModel(rightActions, maxActions: rightActions.count)
        self.leftActions = SwipeableViewActionsViewModel(leftActions, maxActions: leftActions.count)
        self.rounded = rounded
        
        viewModel = SwipeableViewViewModel(state: .center, size: .zero)
        manager = SwipeableViewManager()
        manager.addViewModel(viewModel)
    }
    
    private func makeView(_ geometry: GeometryProxy) -> some View {
        return content
    }
    
    public var body: some View {
        
        let dragGesture = DragGesture(minimumDistance: 1.0, coordinateSpace: .global)
            .onChanged(self.onChanged(value:))
            .onEnded(self.onEnded(value:))
        
        return GeometryReader { reader in
            self.makeLeftActions()
            self.makeView(reader)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: self.viewModel.dragOffset.width)
                .zIndex(100)
//                .onTapGesture(count: 1, perform: { self.toCenterWithAnimation()})
                .highPriorityGesture( dragGesture )
            self.makeRightActions()
        }
    }
    
    private func makeRightActions() -> AnyView {
        
        return AnyView(SwipeableViewActions(viewModel: leftActions,
                                   offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                   state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                   onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                   side: .right,
                                   rounded: rounded)
                        .animation(.easeInOut))
    }
    
    private func makeLeftActions() -> AnyView {
        
        return AnyView(SwipeableViewActions(viewModel: rightActions,
                                   offset: .init(get: {self.viewModel.dragOffset}, set: {self.viewModel.dragOffset = $0}),
                                   state: .init(get: {self.viewModel.state}, set: {self.viewModel.state = $0}),
                                   onChangeSwipe: .init(get: {self.viewModel.onChangeSwipe}, set: {self.viewModel.onChangeSwipe = $0}),
                                   side: .left,
                                   rounded: rounded)
                        .animation(.easeInOut))
    }
    
    private func toCenterWithAnimation() {
        withAnimation(.easeOut) {
            self.viewModel.dragOffset = CGSize.zero
            self.viewModel.state = .center
            self.viewModel.onChangeSwipe = .noChange
            self.viewModel.otherTapped()
        }
    }
    
    private func onChanged(value: DragGesture.Value) {
        
        if self.viewModel.state == .center {
            
            if value.translation.width <= 0  {
                //&& value.translation.height > -60 && value.translation.height < 60
                self.viewModel.onChangeSwipe = .leftStarted
                self.viewModel.dragOffset.width = value.translation.width
                
            } else if self.viewModel.dragOffset.width >= 0 {
                //&& value.translation.height > -60 && value.translation.height < 60
                
                self.viewModel.onChangeSwipe = .rightStarted
                self.viewModel.dragOffset.width = value.translation.width
            }
        } else {
            // print(value.translation.width)
            if self.viewModel.dragOffset.width != .zero {
                self.viewModel.dragOffset.width = finishedOffset.width + value.translation.width
                //  print(self.viewModel.dragOffset.width)
            } else {
                self.viewModel.onChangeSwipe = .noChange
                self.viewModel.state = .center
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value) {
        
        finishedOffset = value.translation
        
        if self.viewModel.dragOffset.width <= 0 {
            // left
            if self.viewModel.state == .center && value.translation.width <= -50 {
                
                var offset = (CGFloat(min(4, self.rightActions.actions.count)) * -80)
                
                if self.rounded {
                    offset -= CGFloat(min(4, self.rightActions.actions.count)) * 5
                }
                withAnimation(.easeOut) {
                    self.viewModel.dragOffset = CGSize.init(width: offset, height: 0)
                    self.viewModel.state = .left
                }
                
            } else {
                self.toCenterWithAnimation()
                finishedOffset = .zero
            }
            
            
        } else if self.viewModel.dragOffset.width >= 0 {
            // right
            if self.viewModel.state == .center && value.translation.width > 50{
                
                var offset = (CGFloat(min(4, self.leftActions.actions.count)) * +80)
                if self.rounded {
                    offset += CGFloat(min(4, self.leftActions.actions.count)) * 5
                }
                withAnimation(.easeOut) {
                    self.viewModel.dragOffset = (CGSize.init(width: offset, height: 0))
                    self.viewModel.state = .right
                }
            } else {
                self.toCenterWithAnimation()
            }
        }
    }
    
}
