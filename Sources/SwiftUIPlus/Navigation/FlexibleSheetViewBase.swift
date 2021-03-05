//
//  FlexibleSheetViewBase.swift
//  
//
//  Created by Alex Nagy on 05.03.2021.
//

import SwiftUI

fileprivate struct FlexibleSheetViewBase<Destination: View>: View {
    
    @State private var translation: CGFloat = 0
    
    @Binding private var isActive: Bool
    private let swipesToDismiss: Bool
    private let ignoresSafeArea: Bool
    private let destination: Destination
    private let onDismiss: () -> ()
    
    fileprivate var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                destination
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, ignoresSafeArea ? 0 : geometry.safeAreaInsets.bottom)
                    .background(
                        Color(.systemBackground)
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if swipesToDismiss {
                                    self.translation = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if swipesToDismiss {
                                    if abs(self.translation) > geometry.size.height * 0.01 {
                                        isActive.toggle()
                                        onDismiss()
                                    }
                                    
                                    self.translation = 0
                                }
                            }
                    )
            }
            .edgesIgnoringSafeArea(.bottom)
            .offset(y: isActive ? self.translation : geometry.size.height - self.translation + geometry.safeAreaInsets.bottom)
            .transition(.move(edge: .bottom))
            .animation(.easeInOut)
            .background(
                Color.black.opacity(isActive ? 0.1 : 0.0).ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut)
            )
        }
    }
    
    fileprivate init(isActive: Binding<Bool>, swipesToDismiss: Bool, ignoresSafeArea: Bool, @ViewBuilder destination: () -> Destination, onDismiss: @escaping () -> () = {}) {
        self._isActive = isActive
        self.swipesToDismiss = swipesToDismiss
        self.destination = destination()
        self.onDismiss = onDismiss
        self.ignoresSafeArea = ignoresSafeArea
    }
}

public extension View {
    func flexibleSheet<Destination: View>(isActive: Binding<Bool>, swipesToDismiss: Bool = true, ignoresSafeArea: Bool = false, @ViewBuilder destination: () -> Destination, onDismiss: @escaping () -> () = {}) -> some View {
        ZStack {
            self.disabled(isActive.wrappedValue)
            FlexibleSheetViewBase(isActive: isActive, swipesToDismiss: swipesToDismiss, ignoresSafeArea: ignoresSafeArea, destination: destination, onDismiss: onDismiss)
        }
    }
}

