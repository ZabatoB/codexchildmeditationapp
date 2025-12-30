import SwiftUI

@Observable
final class HomeViewModel {

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    var childName: String {
        appState.currentChild?.name ?? "Friend"
    }

    var gardenState: GardenState {
        appState.currentChild?.gardenState ?? GardenState()
    }

    var currentStreak: Int {
        guard let child = appState.currentChild else { return 0 }
        return appState.progressService.currentStreak(for: child)
    }

    var hasCompletedToday: Bool {
        guard let child = appState.currentChild else { return false }
        return appState.progressService.hasCompletedPracticeToday(for: child)
    }

    var totalMinutesThisWeek: Int {
        guard let child = appState.currentChild else { return 0 }
        return appState.progressService.weeklyStats(for: child).totalMinutes
    }

    var skillsLearnedCount: Int {
        appState.currentChild?.learnedSkillIds.count ?? 0
    }

    var totalSessions: Int {
        guard let child = appState.currentChild else { return 0 }
        return appState.progressService.sessionCount(for: child)
    }

    var isToolkitUnlocked: Bool {
        appState.isToolkitUnlocked
    }

    var recommendedMeditation: Meditation? {
        guard let child = appState.currentChild else { return nil }

        let sessions = appState.storageService.loadSessions(forChild: child.id)
        let completedIds = sessions.filter { $0.completedFully }.map { $0.meditationId }

        return appState.contentService.nextRecommendedMeditation(
            for: child,
            completedMeditationIds: completedIds
        )
    }

    var nextUnlock: UnlockPreview? {
        guard let child = appState.currentChild else { return nil }
        return appState.progressService.nextUnlock(for: child)
    }

    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = childName

        switch hour {
        case 5..<12: return "Good morning, \(name)!"
        case 12..<17: return "Good afternoon, \(name)!"
        case 17..<21: return "Good evening, \(name)!"
        default: return "Hi, \(name)!"
        }
    }

    var subtitleText: String {
        if hasCompletedToday {
            if currentStreak > 1 {
                return "You're on a \(currentStreak)-day streak! 🔥"
            } else {
                return "Nice practice today!"
            }
        }
        return "Ready to practice?"
    }
}
