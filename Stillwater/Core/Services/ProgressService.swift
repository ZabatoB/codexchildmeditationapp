import Foundation

// MARK: - Progress Service Protocol
protocol ProgressServiceProtocol {
    // Session Tracking
    func recordSession(_ session: Session, for child: inout ChildProfile)
    func sessionCount(for child: ChildProfile) -> Int
    func completedSessionsThisWeek(for child: ChildProfile) -> Int
    func totalPracticeMinutes(for child: ChildProfile) -> Int

    // Skill Tracking
    func learnSkill(_ skillId: UUID, for child: inout ChildProfile)
    func isSkillLearned(_ skillId: UUID, by child: ChildProfile) -> Bool
    func skillProgress(for child: ChildProfile) -> SkillProgress

    // Streak Tracking
    func currentStreak(for child: ChildProfile) -> Int
    func hasCompletedPracticeToday(for child: ChildProfile) -> Bool

    // Garden
    func waterGarden(for child: inout ChildProfile)

    // Content Unlocks
    func isUnlocked(_ meditation: Meditation, for child: ChildProfile) -> Bool
    func isUnlocked(_ adventure: Adventure, for child: ChildProfile) -> Bool
    func nextUnlock(for child: ChildProfile) -> UnlockPreview?

    // Statistics
    func weeklyStats(for child: ChildProfile) -> WeeklyStats
}

// MARK: - Progress Service Implementation
final class ProgressService: ProgressServiceProtocol {

    // MARK: - Dependencies
    private let storageService: StorageServiceProtocol
    private let contentService: ContentServiceProtocol
    private let calendar = Calendar.current

    // MARK: - Initialization
    init(storageService: StorageServiceProtocol, contentService: ContentServiceProtocol) {
        self.storageService = storageService
        self.contentService = contentService
    }

    // MARK: - Session Tracking
    func recordSession(_ session: Session, for child: inout ChildProfile) {
        storageService.saveSession(session)

        if session.completedFully && !child.completedSessionIds.contains(session.id) {
            child.completedSessionIds.append(session.id)
        }

        if let skillId = checkForSkillLearning(session: session, child: child) {
            learnSkill(skillId, for: &child)
        }

        if session.completedFully {
            waterGarden(for: &child)
        }

        storageService.updateChildProfile(child)
    }

    private func checkForSkillLearning(session: Session, child: ChildProfile) -> UUID? {
        guard let meditation = contentService.meditation(id: session.meditationId),
              let skillId = meditation.skillIds.first else { return nil }

        if child.learnedSkillIds.contains(skillId) { return nil }

        let sessions = storageService.loadSessions(forChild: child.id)
        let completedCount = sessions.filter { $0.meditationId == meditation.id && $0.completedFully }.count

        let threshold = contentService.appConfig.skillLearningThreshold
        if completedCount >= threshold {
            return skillId
        }

        return nil
    }

    func sessionCount(for child: ChildProfile) -> Int {
        storageService.loadSessions(forChild: child.id)
            .filter { $0.completedFully }
            .count
    }

    func completedSessionsThisWeek(for child: ChildProfile) -> Int {
        let sessions = storageService.loadSessions(forChild: child.id)
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!

        return sessions.filter { session in
            guard session.completedFully,
                  let completedAt = session.completedAt else { return false }
            return completedAt >= startOfWeek
        }.count
    }

    func totalPracticeMinutes(for child: ChildProfile) -> Int {
        let sessions = storageService.loadSessions(forChild: child.id)

        return sessions.reduce(0) { total, session in
            guard let meditation = contentService.meditation(id: session.meditationId) else { return total }
            return total + meditation.durationMinutes
        }
    }

    // MARK: - Skill Tracking
    func learnSkill(_ skillId: UUID, for child: inout ChildProfile) {
        guard !child.learnedSkillIds.contains(skillId) else { return }
        child.learnedSkillIds.append(skillId)
        storageService.updateChildProfile(child)
    }

    func isSkillLearned(_ skillId: UUID, by child: ChildProfile) -> Bool {
        child.learnedSkillIds.contains(skillId)
    }

    func skillProgress(for child: ChildProfile) -> SkillProgress {
        let allSkills = contentService.allSkills
        let learnedIds = Set(child.learnedSkillIds)

        func progress(for category: Meditation.Category) -> SkillProgress.CategoryProgress {
            let categorySkills = allSkills.filter { $0.category == category }
            let learned = categorySkills.filter { learnedIds.contains($0.id) }.count
            return SkillProgress.CategoryProgress(learned: learned, total: categorySkills.count)
        }

        return SkillProgress(
            breath: progress(for: .breath),
            body: progress(for: .body),
            mind: progress(for: .mind),
            heart: progress(for: .heart)
        )
    }

    // MARK: - Streak Tracking
    func currentStreak(for child: ChildProfile) -> Int {
        let sessions = storageService.loadSessions(forChild: child.id)
            .filter { $0.completedFully }
            .compactMap { $0.completedAt }
            .sorted(by: >)

        guard !sessions.isEmpty else { return 0 }

        let streakResetHours = contentService.appConfig.streakResetHours
        var streak = 0
        var lastDate = Date()

        var practiceDays: [Date] = []
        for sessionDate in sessions {
            let day = calendar.startOfDay(for: sessionDate)
            if !practiceDays.contains(day) {
                practiceDays.append(day)
            }
        }

        practiceDays.sort(by: >)

        for practiceDay in practiceDays {
            let hoursSinceLastPractice = calendar.dateComponents([.hour], from: practiceDay, to: lastDate).hour ?? 0

            if hoursSinceLastPractice <= streakResetHours {
                streak += 1
                lastDate = practiceDay
            } else {
                break
            }
        }

        return streak
    }

    func hasCompletedPracticeToday(for child: ChildProfile) -> Bool {
        let sessions = storageService.loadSessions(forChild: child.id)
        let today = calendar.startOfDay(for: Date())

        return sessions.contains { session in
            guard session.completedFully,
                  let completedAt = session.completedAt else { return false }
            return calendar.startOfDay(for: completedAt) == today
        }
    }

    // MARK: - Garden
    func waterGarden(for child: inout ChildProfile) {
        let growthAmount = contentService.appConfig.gardenGrowthPerSession
        let maxGrowth = contentService.appConfig.maxGardenGrowth

        child.gardenState.plantGrowth = min(maxGrowth, child.gardenState.plantGrowth + growthAmount)
        child.gardenState.lastWatered = Date()

        let newPlantsUnlocked = Int(child.gardenState.plantGrowth * 10)
        if newPlantsUnlocked > child.gardenState.plantsUnlocked {
            child.gardenState.plantsUnlocked = newPlantsUnlocked
        }
    }

    // MARK: - Content Unlocks
    func isUnlocked(_ meditation: Meditation, for child: ChildProfile) -> Bool {
        if !meditation.isLocked { return true }
        guard let required = meditation.unlockAfterSessions else { return true }
        return sessionCount(for: child) >= required
    }

    func isUnlocked(_ adventure: Adventure, for child: ChildProfile) -> Bool {
        if !adventure.isLocked { return true }
        guard let required = adventure.unlockAfterSessions else { return true }
        return sessionCount(for: child) >= required
    }

    func nextUnlock(for child: ChildProfile) -> UnlockPreview? {
        let currentSessionCount = sessionCount(for: child)

        let nextMeditation = contentService.allMeditations
            .filter { $0.isLocked && ($0.unlockAfterSessions ?? 0) > currentSessionCount }
            .sorted { ($0.unlockAfterSessions ?? 0) < ($1.unlockAfterSessions ?? 0) }
            .first

        let nextAdventure = contentService.allAdventures
            .filter { $0.isLocked && ($0.unlockAfterSessions ?? 0) > currentSessionCount }
            .sorted { ($0.unlockAfterSessions ?? 0) < ($1.unlockAfterSessions ?? 0) }
            .first

        if let meditation = nextMeditation,
           let required = meditation.unlockAfterSessions {
            if let adventure = nextAdventure,
               let adventureRequired = adventure.unlockAfterSessions,
               adventureRequired < required {
                return UnlockPreview(
                    type: .adventure,
                    title: adventure.title,
                    sessionsRequired: adventureRequired,
                    sessionsRemaining: adventureRequired - currentSessionCount
                )
            }
            return UnlockPreview(
                type: .meditation,
                title: meditation.title,
                sessionsRequired: required,
                sessionsRemaining: required - currentSessionCount
            )
        }

        if let adventure = nextAdventure,
           let required = adventure.unlockAfterSessions {
            return UnlockPreview(
                type: .adventure,
                title: adventure.title,
                sessionsRequired: required,
                sessionsRemaining: required - currentSessionCount
            )
        }

        return nil
    }

    // MARK: - Statistics
    func weeklyStats(for child: ChildProfile) -> WeeklyStats {
        let sessions = storageService.loadSessions(forChild: child.id)
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!

        let thisWeekSessions = sessions.filter { session in
            guard let completedAt = session.completedAt else { return false }
            return completedAt >= startOfWeek && session.completedFully
        }

        var dailyBreakdown: [WeeklyStats.DailyPractice] = []
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { continue }
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: day)!

            let daySessions = thisWeekSessions.filter { session in
                guard let completedAt = session.completedAt else { return false }
                return completedAt >= day && completedAt < dayEnd
            }

            let minutes = daySessions.reduce(0) { total, session in
                guard let meditation = contentService.meditation(id: session.meditationId) else { return total }
                return total + meditation.durationMinutes
            }

            dailyBreakdown.append(WeeklyStats.DailyPractice(
                date: day,
                sessionCount: daySessions.count,
                minutes: minutes
            ))
        }

        var categoryCounts: [Meditation.Category: Int] = [:]
        for session in thisWeekSessions {
            if let meditation = contentService.meditation(id: session.meditationId) {
                categoryCounts[meditation.category, default: 0] += 1
            }
        }
        let mostPracticed = categoryCounts.max { $0.value < $1.value }?.key

        let totalMinutes = thisWeekSessions.reduce(0) { total, session in
            guard let meditation = contentService.meditation(id: session.meditationId) else { return total }
            return total + meditation.durationMinutes
        }

        let skillsLearnedThisWeek = child.learnedSkillIds.count

        return WeeklyStats(
            sessionsCompleted: thisWeekSessions.count,
            totalMinutes: totalMinutes,
            currentStreak: currentStreak(for: child),
            skillsLearned: skillsLearnedThisWeek,
            mostPracticedCategory: mostPracticed,
            dailyBreakdown: dailyBreakdown
        )
    }
}
