import Foundation

struct SkillProgress {
    let breath: CategoryProgress
    let body: CategoryProgress
    let mind: CategoryProgress
    let heart: CategoryProgress

    struct CategoryProgress {
        let learned: Int
        let total: Int

        var percentage: Double {
            total > 0 ? Double(learned) / Double(total) : 0
        }

        var displayText: String {
            "\(learned)/\(total)"
        }
    }

    var totalLearned: Int {
        breath.learned + body.learned + mind.learned + heart.learned
    }

    var totalSkills: Int {
        breath.total + body.total + mind.total + heart.total
    }

    var overallPercentage: Double {
        totalSkills > 0 ? Double(totalLearned) / Double(totalSkills) : 0
    }
}

struct WeeklyStats {
    let sessionsCompleted: Int
    let totalMinutes: Int
    let currentStreak: Int
    let skillsLearned: Int
    let mostPracticedCategory: Meditation.Category?
    let dailyBreakdown: [DailyPractice]

    struct DailyPractice: Identifiable {
        let date: Date
        let sessionCount: Int
        let minutes: Int

        var id: Date { date }

        var dayName: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"
            return formatter.string(from: date)
        }
    }
}

struct UnlockPreview {
    let type: UnlockType
    let title: String
    let sessionsRequired: Int
    let sessionsRemaining: Int

    enum UnlockType {
        case meditation
        case adventure
        case skill
    }

    var progressPercentage: Double {
        guard sessionsRequired > 0 else { return 1.0 }
        return Double(sessionsRequired - sessionsRemaining) / Double(sessionsRequired)
    }
}
