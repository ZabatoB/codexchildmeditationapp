import Foundation

struct ToolkitUsage: Codable, Identifiable {
    let id: UUID
    let childId: UUID
    let protocolId: UUID
    let initialFeeling: Feeling
    var resultFeeling: Feeling?
    let startedAt: Date
    var completedAt: Date?
    var completedFully: Bool

    init(
        childId: UUID,
        protocolId: UUID,
        initialFeeling: Feeling
    ) {
        self.id = UUID()
        self.childId = childId
        self.protocolId = protocolId
        self.initialFeeling = initialFeeling
        self.resultFeeling = nil
        self.startedAt = Date()
        self.completedAt = nil
        self.completedFully = false
    }

    mutating func complete(resultFeeling: Feeling?) {
        self.resultFeeling = resultFeeling
        self.completedAt = Date()
        self.completedFully = true
    }
}
