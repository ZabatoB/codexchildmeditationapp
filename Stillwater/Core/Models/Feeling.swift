import SwiftUI

enum Feeling: String, Codable, CaseIterable, Identifiable {
    // Post-session feelings
    case calm
    case same
    case unsure

    // Toolkit initial feelings
    case angry
    case worried
    case sad
    case overwhelmed
    case cantSleep

    // Toolkit result feelings
    case better
    case littleBetter
    case stillAngry
    case stillWorried
    case stillSad
    case stillOverwhelmed
    case stillCantSleep

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .calm: return "Calm"
        case .same: return "About the same"
        case .unsure: return "Not sure"
        case .angry: return "Angry"
        case .worried: return "Worried"
        case .sad: return "Sad"
        case .overwhelmed: return "Overwhelmed"
        case .cantSleep: return "Can't sleep"
        case .better: return "Better"
        case .littleBetter: return "A little better"
        case .stillAngry: return "Still angry"
        case .stillWorried: return "Still worried"
        case .stillSad: return "Still sad"
        case .stillOverwhelmed: return "Still overwhelmed"
        case .stillCantSleep: return "Still can't sleep"
        }
    }

    var emoji: String {
        switch self {
        case .calm: return "😌"
        case .same: return "😐"
        case .unsure: return "🤔"
        case .angry: return "😠"
        case .worried: return "😰"
        case .sad: return "😢"
        case .overwhelmed: return "😵"
        case .cantSleep: return "😴"
        case .better: return "😊"
        case .littleBetter: return "🙂"
        case .stillAngry: return "😠"
        case .stillWorried: return "😰"
        case .stillSad: return "😢"
        case .stillOverwhelmed: return "😵"
        case .stillCantSleep: return "😴"
        }
    }

    var color: Color {
        switch self {
        case .calm, .better, .littleBetter:
            return StillwaterColors.sage
        case .same, .unsure:
            return StillwaterColors.sand
        case .angry, .stillAngry:
            return Color(hex: "D98A7B")
        case .worried, .stillWorried:
            return StillwaterColors.sky
        case .sad, .stillSad:
            return Color(hex: "8B9DC3")
        case .overwhelmed, .stillOverwhelmed:
            return Color(hex: "C9A87C")
        case .cantSleep, .stillCantSleep:
            return StillwaterColors.lavender
        }
    }

    var iconName: String {
        switch self {
        case .calm, .better, .littleBetter:
            return StillwaterIcon.emotionCalm
        case .same, .unsure:
            return StillwaterIcon.emotionUnsure
        case .angry, .stillAngry:
            return StillwaterIcon.emotionAngry
        case .worried, .stillWorried:
            return StillwaterIcon.emotionWorried
        case .sad, .stillSad:
            return StillwaterIcon.emotionSad
        case .overwhelmed, .stillOverwhelmed:
            return StillwaterIcon.emotionOverwhelmed
        case .cantSleep, .stillCantSleep:
            return StillwaterIcon.emotionSleepy
        }
    }

    static let postSessionFeelings: [Feeling] = [.calm, .same, .unsure]
    static let toolkitFeelings: [Feeling] = [.angry, .worried, .sad, .overwhelmed, .cantSleep]
}
