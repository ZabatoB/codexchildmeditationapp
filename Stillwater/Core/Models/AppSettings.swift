import Foundation

struct AppSettings: Codable, Equatable {
    var hasCompletedOnboarding: Bool
    var parentPIN: String?
    var currentChildId: UUID?
    var maxSessionLengthMinutes: Int
    var notificationsEnabled: Bool
    var bedtimeModeEnabled: Bool
    var bedtimeHour: Int

    init(
        hasCompletedOnboarding: Bool = false,
        parentPIN: String? = nil,
        currentChildId: UUID? = nil,
        maxSessionLengthMinutes: Int = 10,
        notificationsEnabled: Bool = false,
        bedtimeModeEnabled: Bool = false,
        bedtimeHour: Int = 19
    ) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.parentPIN = parentPIN
        self.currentChildId = currentChildId
        self.maxSessionLengthMinutes = maxSessionLengthMinutes
        self.notificationsEnabled = notificationsEnabled
        self.bedtimeModeEnabled = bedtimeModeEnabled
        self.bedtimeHour = bedtimeHour
    }
}
