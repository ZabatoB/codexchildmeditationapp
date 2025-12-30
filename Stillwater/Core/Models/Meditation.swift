import Foundation
import SwiftUI

struct Meditation: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let shortDescription: String
    let durationMinutes: Int
    let category: Category
    let ageRanges: [ChildProfile.AgeRange]
    let skillIds: [UUID]
    let thumbnailName: String
    let isLocked: Bool
    let unlockAfterSessions: Int?
    let sortOrder: Int
    let segments: [MeditationSegment]

    enum Category: String, Codable, CaseIterable {
        case breath
        case body
        case mind
        case heart

        var displayName: String {
            switch self {
            case .breath: return "Breath"
            case .body: return "Body"
            case .mind: return "Mind"
            case .heart: return "Heart"
            }
        }

        var iconName: String {
            switch self {
            case .breath: return StillwaterIcon.breath
            case .body: return StillwaterIcon.body
            case .mind: return StillwaterIcon.mind
            case .heart: return StillwaterIcon.heart
            }
        }

        var color: Color {
            switch self {
            case .breath: return StillwaterColors.sky
            case .body: return StillwaterColors.sunrise
            case .mind: return StillwaterColors.lavender
            case .heart: return StillwaterColors.sage
            }
        }
    }
}
