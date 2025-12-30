import Foundation

struct Session: Identifiable, Codable, Equatable {
    let id: UUID
    let childId: UUID
    let meditationId: UUID
    let startedAt: Date
    var completedAt: Date?
    var preFeeling: Feeling?
    var postFeeling: Feeling?
    var completedFully: Bool

    init(
        id: UUID = UUID(),
        childId: UUID,
        meditationId: UUID,
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        preFeeling: Feeling? = nil,
        postFeeling: Feeling? = nil,
        completedFully: Bool = false
    ) {
        self.id = id
        self.childId = childId
        self.meditationId = meditationId
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.preFeeling = preFeeling
        self.postFeeling = postFeeling
        self.completedFully = completedFully
    }

    mutating func complete(with feeling: Feeling?) {
        completedAt = Date()
        postFeeling = feeling
        completedFully = true
    }
}
