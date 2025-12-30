import SwiftUI

@Observable
final class ParentDashboardViewModel {

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    var childName: String {
        appState.currentChild?.name ?? "Child"
    }

    var lastPracticeDate: Date? {
        guard let child = appState.currentChild else { return nil }

        let sessions = appState.storageService.loadSessions(forChild: child.id)
        return sessions
            .filter { $0.completedFully }
            .compactMap { $0.completedAt }
            .sorted()
            .last
    }

    var weeklyData: WeeklyPracticeData {
        guard let child = appState.currentChild else {
            return WeeklyPracticeData(
                days: [],
                totalSessions: 0,
                totalMinutes: 0,
                currentStreak: 0,
                skillsLearnedThisWeek: 0
            )
        }

        let stats = appState.progressService.weeklyStats(for: child)

        let days = stats.dailyBreakdown.map { day in
            WeeklyPracticeData.DayPractice(
                date: day.date,
                sessionCount: day.sessionCount,
                minutes: day.minutes
            )
        }

        return WeeklyPracticeData(
            days: days,
            totalSessions: stats.sessionsCompleted,
            totalMinutes: stats.totalMinutes,
            currentStreak: stats.currentStreak,
            skillsLearnedThisWeek: stats.skillsLearned
        )
    }

    var emotionalInsights: EmotionalInsights {
        guard let child = appState.currentChild else {
            return EmotionalInsights(
                toolkitUsageByFeeling: [:],
                mostUsedToolkitFeeling: nil,
                postSessionCalmerRate: 0,
                totalToolkitUses: 0,
                recentToolkitSessions: []
            )
        }

        let toolkitUsage = appState.storageService.loadToolkitUsage(forChild: child.id)

        var usageByFeeling: [Feeling: Int] = [:]
        for usage in toolkitUsage {
            usageByFeeling[usage.initialFeeling, default: 0] += 1
        }

        let mostUsed = usageByFeeling.max { $0.value < $1.value }?.key

        let sessions = appState.storageService.loadSessions(forChild: child.id)
        let completedWithFeeling = sessions.filter { $0.completedFully && $0.postFeeling != nil }
        let calmerCount = completedWithFeeling.filter { $0.postFeeling == .calm || $0.postFeeling == .better }.count
        let calmerRate = completedWithFeeling.isEmpty ? 0.0 : Double(calmerCount) / Double(completedWithFeeling.count)

        return EmotionalInsights(
            toolkitUsageByFeeling: usageByFeeling,
            mostUsedToolkitFeeling: mostUsed,
            postSessionCalmerRate: calmerRate,
            totalToolkitUses: toolkitUsage.count,
            recentToolkitSessions: []
        )
    }

    var skillProgress: SkillProgressSummary {
        guard let child = appState.currentChild else {
            return SkillProgressSummary(
                byCategory: [:],
                totalLearned: 0,
                totalAvailable: 0
            )
        }

        let progress = appState.progressService.skillProgress(for: child)

        var byCategory: [Meditation.Category: SkillProgressSummary.CategoryProgress] = [:]
        byCategory[.breath] = SkillProgressSummary.CategoryProgress(
            learned: progress.breath.learned,
            total: progress.breath.total
        )
        byCategory[.body] = SkillProgressSummary.CategoryProgress(
            learned: progress.body.learned,
            total: progress.body.total
        )
        byCategory[.mind] = SkillProgressSummary.CategoryProgress(
            learned: progress.mind.learned,
            total: progress.mind.total
        )
        byCategory[.heart] = SkillProgressSummary.CategoryProgress(
            learned: progress.heart.learned,
            total: progress.heart.total
        )

        return SkillProgressSummary(
            byCategory: byCategory,
            totalLearned: progress.totalLearned,
            totalAvailable: progress.totalSkills
        )
    }
}

struct WeeklyPracticeData {
    let days: [DayPractice]
    let totalSessions: Int
    let totalMinutes: Int
    let currentStreak: Int
    let skillsLearnedThisWeek: Int

    struct DayPractice: Identifiable {
        let date: Date
        let sessionCount: Int
        let minutes: Int

        var id: Date { date }

        var hasActivity: Bool { sessionCount > 0 }

        var dayLetter: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "E"
            return String(formatter.string(from: date).prefix(1))
        }
    }
}

struct EmotionalInsights {
    let toolkitUsageByFeeling: [Feeling: Int]
    let mostUsedToolkitFeeling: Feeling?
    let postSessionCalmerRate: Double
    let totalToolkitUses: Int
    let recentToolkitSessions: [ToolkitSession]

    struct ToolkitSession: Identifiable {
        let id: UUID
        let date: Date
        let initialFeeling: Feeling
        let resultFeeling: Feeling?
        let protocolTitle: String
    }
}

struct SkillProgressSummary {
    let byCategory: [Meditation.Category: CategoryProgress]
    let totalLearned: Int
    let totalAvailable: Int

    struct CategoryProgress {
        let learned: Int
        let total: Int

        var percentage: Double {
            total > 0 ? Double(learned) / Double(total) : 0
        }
    }
}
