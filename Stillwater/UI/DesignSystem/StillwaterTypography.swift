import SwiftUI

struct StillwaterFont {
    // MARK: Display (Large titles, hero text)
    static let displayLarge = Font.system(size: 40, weight: .bold, design: .rounded)
    static let displayMedium = Font.system(size: 34, weight: .bold, design: .rounded)
    static let displaySmall = Font.system(size: 28, weight: .semibold, design: .rounded)

    // MARK: Headlines
    static let headlineLarge = Font.system(size: 24, weight: .semibold, design: .rounded)
    static let headlineMedium = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headlineSmall = Font.system(size: 18, weight: .semibold, design: .rounded)

    // MARK: Body
    static let bodyLarge = Font.system(size: 18, weight: .regular, design: .rounded)
    static let bodyMedium = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .rounded)

    // MARK: Labels
    static let labelLarge = Font.system(size: 16, weight: .medium, design: .rounded)
    static let labelMedium = Font.system(size: 14, weight: .medium, design: .rounded)
    static let labelSmall = Font.system(size: 12, weight: .medium, design: .rounded)

    // MARK: Special
    static let miloSpeaking = Font.system(size: 22, weight: .medium, design: .rounded)
    static let miloSpeakingSmall = Font.system(size: 18, weight: .medium, design: .rounded)
    static let buttonText = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let buttonTextSmall = Font.system(size: 16, weight: .medium, design: .rounded)
    static let caption = Font.system(size: 12, weight: .regular, design: .rounded)
}

// MARK: - Line Spacing
struct StillwaterLineSpacing {
    static let display: CGFloat = 4
    static let body: CGFloat = 6
    static let milo: CGFloat = 8
}
