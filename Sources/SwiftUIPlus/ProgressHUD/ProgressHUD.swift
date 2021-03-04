//
//  ProgressHUD.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct ProgressHUDConfig: Hashable {
    var title: String?
    var caption: String?

    var minSize: CGSize
    var cornerRadius: CGFloat

    var backgroundColor: Color

    var titleForegroundColor: Color
    var captionForegroundColor: Color

    var shadowColor: Color
    var shadowRadius: CGFloat

    var borderColor: Color
    var borderWidth: CGFloat

    // Auto hide
    var shouldAutoHide: Bool
    var allowsTapToHide: Bool
    var autoHideInterval: TimeInterval

    public init(
        minSize: CGSize = CGSize(width: 100.0, height: 100.0),
        cornerRadius: CGFloat = 12.0,
        backgroundColor: Color = .clear,
        titleForegroundColor: Color = .primary,
        captionForegroundColor: Color = .secondary,
        shadowColor: Color = .clear,
        shadowRadius: CGFloat = 0.0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0.0,
        shouldAutoHide: Bool = false,
        allowsTapToHide: Bool = false,
        autoHideInterval: TimeInterval = 10.0
    ) {
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
    }
}

private struct ProgressHUDLabelView: View {
    var title: String?
    var caption: String?
    
    var body: some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.system(size: 21.0, weight: .semibold))
                    .lineLimit(1)
                    .foregroundColor(.primary)
            }
            if let caption = caption {
                Text(caption)
                    .lineLimit(2)
                    .font(.headline)
                    .foregroundColor(.secondary)
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
                    
                    ZStack {
                        Color.white
                            .blurEffect()
                            .blurEffectStyle(.systemChromeMaterial)
                        
                        VStack(spacing: 20) {
                            ProgressView()
                            ProgressHUDLabelView(title: config.title, caption: config.caption)
                        }.padding()
                    }
                    .cornerRadius(config.cornerRadius)
                    .overlay(
                        // Fix required since .border can not be used with
                        // RoundedRectangle clip shape
                        RoundedRectangle(cornerRadius: config.cornerRadius)
                            .stroke(config.borderColor, lineWidth: config.borderWidth)
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .padding(geometry.size.width / 10)
                    .shadow(color: config.shadowColor, radius: config.shadowRadius)
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
