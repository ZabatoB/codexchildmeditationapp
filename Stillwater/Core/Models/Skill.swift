import Foundation

struct Skill: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let category: Meditation.Category
    let iconName: String
    let technique: String
    let useWhen: String
    let sortOrder: Int
}
