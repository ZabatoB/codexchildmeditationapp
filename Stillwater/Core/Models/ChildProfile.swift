import Foundation

struct ChildProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var ageRange: AgeRange
    var avatarName: String
    var gardenState: GardenState
    var completedSessionIds: [UUID]
    var learnedSkillIds: [UUID]
    let createdAt: Date

    enum AgeRange: String, Codable, CaseIterable {
        case young = "4-6"
        case middle = "7-9"
        case older = "10-12"

        var displayName: String {
            switch self {
            case .young: return "Ages 4-6"
            case .middle: return "Ages 7-9"
            case .older: return "Ages 10-12"
            }
        }
    }

    init(
        id: UUID = UUID(),
        name: String,
        ageRange: AgeRange,
        avatarName: String = "avatar-default",
        gardenState: GardenState = GardenState(),
        completedSessionIds: [UUID] = [],
        learnedSkillIds: [UUID] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.ageRange = ageRange
        self.avatarName = avatarName
        self.gardenState = gardenState
        self.completedSessionIds = completedSessionIds
        self.learnedSkillIds = learnedSkillIds
        self.createdAt = createdAt
    }
}
