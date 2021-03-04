//
//  ProgressHUD.swift
//  
//
//  Created by Alex Nagy on 04.03.2021.
//

import SwiftUI

public struct ProgressHUDConfig: Hashable {
    var type = ProgressHUDType.loading
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

    var lineWidth: CGFloat

    // indefinite animated view and image share the size
    var imageViewSize: CGSize
    var imageViewForegroundColor: Color

    var successImage: String
    var warningImage: String
    var errorImage: String

    // Auto hide
    var shouldAutoHide: Bool
    var allowsTapToHide: Bool
    var autoHideInterval: TimeInterval

    // Haptics
    var hapticsEnabled: Bool

    public init(
        type: ProgressHUDType = .loading,
        minSize: CGSize = CGSize(width: 100.0, height: 100.0),
        cornerRadius: CGFloat = 12.0,
        backgroundColor: Color = .clear,
        titleForegroundColor: Color = .primary,
        captionForegroundColor: Color = .secondary,
        shadowColor: Color = .clear,
        shadowRadius: CGFloat = 0.0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0.0,
        lineWidth: CGFloat = 10.0,
        imageViewSize: CGSize = CGSize(width: 100, height: 100),
        imageViewForegroundColor: Color = .primary,
        successImage: String = "checkmark.circle",
        warningImage: String = "exclamationmark.circle",
        errorImage: String = "xmark.circle",
        shouldAutoHide: Bool = false,
        allowsTapToHide: Bool = false,
        autoHideInterval: TimeInterval = 10.0,
        hapticsEnabled: Bool = true
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

        self.lineWidth = lineWidth

        self.imageViewSize = imageViewSize
        self.imageViewForegroundColor = imageViewForegroundColor

        self.successImage = successImage
        self.warningImage = warningImage
        self.errorImage = errorImage

        self.shouldAutoHide = shouldAutoHide
        self.allowsTapToHide = allowsTapToHide
        self.autoHideInterval = autoHideInterval

        self.hapticsEnabled = hapticsEnabled
    }
}

public enum ProgressHUDType {
    case loading
    case activity
    case success
    case warning
    case error
}

private struct ProgressHUDIndefiniteAnimatedView: View {
    var animatedViewSize: CGSize
    var animatedViewForegroundColor: Color
    
    var lineWidth: CGFloat
    
    @State private var isAnimating = false
    
    private var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        let gradient = Gradient(colors: [animatedViewForegroundColor, .clear])
        let radGradient = AngularGradient(gradient: gradient, center: .center, angle: .degrees(-5))
        
        Circle()
            .trim(from: 0.0, to: 0.97)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(radGradient)
            .frame(width: animatedViewSize.width-lineWidth/2, height: animatedViewSize.height-lineWidth/2)
            .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
            .animation(self.isAnimating ? foreverAnimation : .default)
            .padding(lineWidth/2)
            .onAppear {
                self.isAnimating = true
            }
            .onDisappear {
                self.isAnimating = false
            }
    }
}

private struct ProgressHUDImageView: View {
    var type: ProgressHUDType
    
    var imageViewSize: CGSize
    var imageViewForegroundColor: Color
    
    var successImage: String
    var warningImage: String
    var errorImage: String
    
    var body: some View {
        imageForHUDType?
            .resizable()
            .frame(width: imageViewSize.width, height: imageViewSize.height)
            .foregroundColor(imageViewForegroundColor.opacity(0.8))
    }
    
    var imageForHUDType: Image? {
        switch type {
        case .success:
            return Image(systemName: successImage)
        case .warning:
            return Image(systemName: warningImage)
        case .error:
            return Image(systemName: errorImage)
        default:
            return nil
        }
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
                            if config.type == .loading {
                                ProgressHUDIndefiniteAnimatedView(
                                    animatedViewSize: config.imageViewSize,
                                    animatedViewForegroundColor: config.imageViewForegroundColor,
                                    lineWidth: config.lineWidth
                                )
                            } else if config.type == .activity {
                                ProgressView()
                            } else {
                                ProgressHUDImageView(
                                    type: config.type,
                                    imageViewSize: config.imageViewSize,
                                    imageViewForegroundColor: config.imageViewForegroundColor,
                                    successImage: config.successImage,
                                    warningImage: config.warningImage,
                                    errorImage: config.errorImage
                                )
                            }
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
                    .padding(geometry.size.width / 7)
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
            .onAppear {
                if config.hapticsEnabled {
                    generateHapticNotification(for: config.type)
                }
            }
        }
    }
    
    func generateHapticNotification(for type: ProgressHUDType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        switch type {
        case .success:
            generator.notificationOccurred(.success)
        case .warning:
            generator.notificationOccurred(.warning)
        case .error:
            generator.notificationOccurred(.error)
        default:
            return
        }
    }
}
