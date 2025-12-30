import Foundation

struct Adventure: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let description: String
    let durationMinutes: Int
    let ageRanges: [ChildProfile.AgeRange]
    let concept: String
    let skillsTaught: [String]
    let thumbnailName: String
    let isLocked: Bool
    let unlockAfterSessions: Int?
    let sortOrder: Int
    let segments: [MeditationSegment]
}
