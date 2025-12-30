import SwiftUI

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Stillwater Colors
struct StillwaterColors {
    // MARK: Primary Colors
    static let sage = Color(hex: "7BA382")           // Primary green - calm, growth
    static let sky = Color(hex: "89B4C8")            // Secondary blue - peace
    static let sand = Color(hex: "E8DFD0")           // Warm neutral - grounding
    static let sunrise = Color(hex: "E8A87C")        // Accent warm - gentle energy
    static let lavender = Color(hex: "C9B8D9")       // Accent cool - sleep, calm

    // MARK: Background Colors
    static let bgPrimary = Color(hex: "FDFBF7")      // Warm off-white
    static let bgSecondary = Color(hex: "F5F1EA")    // Slightly darker
    static let bgTertiary = Color(hex: "EDE7DC")     // Card backgrounds

    // MARK: Night Mode Backgrounds
    static let nightPrimary = Color(hex: "1E2A38")   // Deep calm blue-gray
    static let nightSecondary = Color(hex: "2A3847") // Slightly lighter
    static let nightTertiary = Color(hex: "354454")  // Cards at night

    // MARK: Text Colors
    static let textPrimary = Color(hex: "2D3B45")    // Main text
    static let textSecondary = Color(hex: "6B7C8A")  // Secondary text
    static let textTertiary = Color(hex: "9AABB8")   // Hint text
    static let textOnDark = Color(hex: "F5F1EA")     // Text on dark backgrounds

    // MARK: Emotion Colors
    static let calm = Color(hex: "7BA382")           // Same as sage
    static let worried = Color(hex: "89B4C8")        // Same as sky
    static let angry = Color(hex: "D98A7B")          // Muted coral
    static let sad = Color(hex: "8B9DC3")            // Muted blue-purple
    static let overwhelmed = Color(hex: "C9A87C")    // Muted gold
    static let sleepy = Color(hex: "C9B8D9")         // Same as lavender

    // MARK: State Colors
    static let success = Color(hex: "7BA382")        // Sage
    static let warning = Color(hex: "E8A87C")        // Sunrise
    static let error = Color(hex: "C97B7B")          // Muted red
}

// MARK: - Gradients
struct StillwaterGradients {
    static let daytime = LinearGradient(
        colors: [
            Color(hex: "FDFBF7"),
            Color(hex: "E8DFD0").opacity(0.5)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let evening = LinearGradient(
        colors: [
            Color(hex: "E8DFD0"),
            Color(hex: "C9B8D9").opacity(0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let night = LinearGradient(
        colors: [
            Color(hex: "1E2A38"),
            Color(hex: "2A3847")
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let breathing = LinearGradient(
        colors: [
            Color(hex: "89B4C8").opacity(0.3),
            Color(hex: "7BA382").opacity(0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let card = LinearGradient(
        colors: [
            Color.white,
            Color(hex: "F5F1EA")
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}
