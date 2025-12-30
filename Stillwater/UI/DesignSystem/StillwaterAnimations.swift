import SwiftUI

struct StillwaterAnimation {
    // MARK: Durations
    static let instant: Double = 0.1
    static let quick: Double = 0.2
    static let standard: Double = 0.35
    static let slow: Double = 0.5
    static let gentle: Double = 0.8
    static let breathing: Double = 4.0

    // MARK: Standard Animations
    static let quickEase = Animation.easeInOut(duration: quick)
    static let standardEase = Animation.easeInOut(duration: standard)
    static let slowEase = Animation.easeInOut(duration: slow)
    static let gentleEase = Animation.easeInOut(duration: gentle)

    // MARK: Spring Animations
    static let softBounce = Animation.spring(response: 0.5, dampingFraction: 0.7)
    static let gentleBounce = Animation.spring(response: 0.6, dampingFraction: 0.8)
    static let subtleBounce = Animation.spring(response: 0.4, dampingFraction: 0.9)

    // MARK: Breathing Animations
    static func breatheIn(duration: Double = 4.0) -> Animation {
        Animation.easeInOut(duration: duration)
    }

    static func breatheOut(duration: Double = 4.0) -> Animation {
        Animation.easeInOut(duration: duration)
    }

    static func breatheHold(duration: Double = 2.0) -> Animation {
        Animation.linear(duration: duration)
    }
}

// MARK: - Transitions
extension AnyTransition {
    static var stillwaterFade: AnyTransition {
        .opacity.animation(StillwaterAnimation.standardEase)
    }

    static var stillwaterSlideUp: AnyTransition {
        .move(edge: .bottom).combined(with: .opacity)
    }

    static var stillwaterScale: AnyTransition {
        .scale(scale: 0.9).combined(with: .opacity)
    }
}
