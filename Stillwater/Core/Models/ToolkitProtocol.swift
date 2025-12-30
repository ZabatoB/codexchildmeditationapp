import Foundation

struct ToolkitProtocol: Identifiable, Codable, Equatable {
    let id: UUID
    let feeling: Feeling
    let title: String
    let description: String
    let durationMinutes: Int
    let segments: [MeditationSegment]
}
