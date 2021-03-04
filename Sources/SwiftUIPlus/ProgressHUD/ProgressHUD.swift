//
//  ProgressHUD.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

/// Configure the ProgressHUD
public struct ProgressHUDConfig: Hashable {
    var title: String?
    var caption: String?
    
    var type: ProgressHUDType

    var minSize: CGSize
    var cornerRadius: CGFloat

    var backgroundColor: Color

    var titleForegroundColor: Color
    var captionForegroundColor: Color

    var shadowColor: Color
    var shadowRadius: CGFloat

    var borderColor: Color
    var borderWidth: CGFloat

    var shouldAutoHide: Bool
    var allowsTapToHide: Bool
    var autoHideInterval: TimeInterval
    var shouldDisableContent: Bool
    
    /// Creates a configuration for ProgressHUD
    /// - Parameters:
    ///   - type: hud type
    ///   - minSize: minimum size of the hud
    ///   - cornerRadius: hud corenre radius
    ///   - backgroundColor: hud background color
    ///   - titleForegroundColor: title foreground color
    ///   - captionForegroundColor: caption foreground color
    ///   - shadowColor: hud shadow color
    ///   - shadowRadius: hud shadow radius
    ///   - borderColor: hud border color
    ///   - borderWidth: hud border width
    ///   - shouldAutoHide: should the hud auto hide
    ///   - allowsTapToHide: should the hud allow tap to hide
    ///   - autoHideInterval: autohide time
    ///   - shouldDisableContent: should the hud disable the underlying content
    public init(
        type: ProgressHUDType = .top,
        minSize: CGSize = CGSize(width: 100.0, height: 100.0),
        cornerRadius: CGFloat = 18.0,
        backgroundColor: Color = .clear,
        titleForegroundColor: Color = .primary,
        captionForegroundColor: Color = .secondary,
        shadowColor: Color = .clear,
        shadowRadius: CGFloat = 0.0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0.0,
        shouldAutoHide: Bool = false,
        allowsTapToHide: Bool = false,
        autoHideInterval: TimeInterval = 10.0,
        shouldDisableContent: Bool = true
    ) {
        self.type = type
        
        self.minSize = minSize
        self.cornerRadius = cornerRadius

        self.backgroundColor = backgroundColor

        self.titleForegroundColor = titleForegroundColor
        self.captionForegroundColor = captionForegroundColor

        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius

        self.borderColor = borderColor
        self.borderWidth = borderWidth

        self.shouldAutoHide = shouldAutoHide
        self.allowsTapToHide = allowsTapToHide
        self.autoHideInterval = autoHideInterval
        
        self.shouldDisableContent = shouldDisableContent
    }
}

public enum ProgressHUDType {
    case top
    case center
    case bottom
}

private struct ProgressHUDLabelView: View {
    
    var type: ProgressHUDType
    
    var title: String?
    var caption: String?
    
    var titleForegroundColor: Color
    var captionForegroundColor: Color
    
    var body: some View {
        Group {
            switch type {
            case .top, .bottom:
                VStack(spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 12.0, weight: .semibold))
                            .lineLimit(2)
                            .foregroundColor(.primary)
                    }
                    if let caption = caption {
                        Text(caption)
                            .lineLimit(2)
                            .font(.system(size: 11.0, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            case .center:
                VStack(spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 16.0, weight: .semibold))
                            .lineLimit(2)
                            .foregroundColor(.primary)
                    }
                    if let caption = caption {
                        Text(caption)
                            .lineLimit(2)
                            .font(.system(size: 14.0, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
        
        .multilineTextAlignment(.center)
        .vibrancyEffect()
        .vibrancyEffectStyle(.fill)
    }
}

public struct ProgressHUD: View {
    @Binding var isVisible: Bool
    var config: ProgressHUDConfig
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ isVisible: Binding<Bool>, config: ProgressHUDConfig) {
        self._isVisible = isVisible
        self.config = config
    }
    
    public var body: some View {
        let hideTimer = Timer.publish(every: config.autoHideInterval, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            ZStack {
                if isVisible {
                    config.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    switch config.type {
                    case .top:
                        VStack {
                            HStack(spacing: 20) {
                                ProgressView()
                                if config.title != nil {
                                    ProgressHUDLabelView(type: config.type, title: config.title, caption: config.caption, titleForegroundColor: config.titleForegroundColor, captionForegroundColor: config.captionForegroundColor)
                                }
                            }
                            .padding()
                            .background(
                                Color.white
                                    .blurEffect()
                                    .blurEffectStyle(.systemChromeMaterial)
                            )
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .overlay(
                                // Fix required since .border can not be used with
                                // RoundedRectangle clip shape
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .stroke(config.borderColor, lineWidth: config.borderWidth)
                            )
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                            
                            Spacer()
                        }
                        
                    case .center:
                        VStack {
                            HStack(spacing: 20) {
                                ProgressView()
                                if config.title != nil {
                                    ProgressHUDLabelView(type: config.type, title: config.title, caption: config.caption, titleForegroundColor: config.titleForegroundColor, captionForegroundColor: config.captionForegroundColor)
                                }
                            }
                            .padding()
                            .background(
                                Color.white
                                    .blurEffect()
                                    .blurEffectStyle(.systemChromeMaterial)
                            )
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .overlay(
                                // Fix required since .border can not be used with
                                // RoundedRectangle clip shape
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .stroke(config.borderColor, lineWidth: config.borderWidth)
                            )
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                        }
                        
                    case .bottom:
                        VStack {
                            Spacer()
                            
                            HStack(spacing: 20) {
                                ProgressView()
                                if config.title != nil {
                                    ProgressHUDLabelView(type: config.type, title: config.title, caption: config.caption, titleForegroundColor: config.titleForegroundColor, captionForegroundColor: config.captionForegroundColor)
                                }
                            }
                            .padding()
                            .background(
                                Color.white
                                    .blurEffect()
                                    .blurEffectStyle(.systemChromeMaterial)
                            )
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .overlay(
                                // Fix required since .border can not be used with
                                // RoundedRectangle clip shape
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .stroke(config.borderColor, lineWidth: config.borderWidth)
                            )
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                        }
                        
                    }
                    
                }
            }
            .animation(.spring())
            .onTapGesture {
                if config.allowsTapToHide {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
            .onReceive(hideTimer) { _ in
                if config.shouldAutoHide {
                    withAnimation {
                        isVisible = false
                    }
                }
                // Only one call required
                hideTimer.upstream.connect().cancel()
            }
        }
    }
    
}
