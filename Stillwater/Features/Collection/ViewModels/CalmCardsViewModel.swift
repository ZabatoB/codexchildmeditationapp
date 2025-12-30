import SwiftUI

@Observable
final class CalmCardsViewModel {

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    var skillsByCategory: [Meditation.Category: [SkillWithState]] {
        var result: [Meditation.Category: [SkillWithState]] = [:]

        for category in Meditation.Category.allCases {
            let skills = appState.contentService.skills(for: category)
            result[category] = skills.map { skill in
                SkillWithState(
                    skill: skill,
                    state: stateFor(skill)
                )
            }.sorted { $0.skill.sortOrder < $1.skill.sortOrder }
        }

        return result
    }

    var totalSkills: Int {
        appState.contentService.allSkills.count
    }

    var learnedSkillsCount: Int {
        appState.currentChild?.learnedSkillIds.count ?? 0
    }

    var progressPercentage: Double {
        guard totalSkills > 0 else { return 0 }
        return Double(learnedSkillsCount) / Double(totalSkills)
    }

    private func stateFor(_ skill: Skill) -> SkillCardState {
        guard let child = appState.currentChild else { return .locked }

        if child.learnedSkillIds.contains(skill.id) {
            let practiceCount = countPractices(for: skill)
            return .learned(practiceCount: practiceCount)
        }

        let meditation = appState.contentService.allMeditations
            .first { $0.skillIds.contains(skill.id) }

        if let meditation = meditation {
            let isUnlocked = appState.progressService.isUnlocked(meditation, for: child)
            return isUnlocked ? .unlocked : .locked
        }

        return .locked
    }

    private func countPractices(for skill: Skill) -> Int {
        guard let child = appState.currentChild else { return 0 }

        let meditationIds = appState.contentService.allMeditations
            .filter { $0.skillIds.contains(skill.id) }
            .map { $0.id }

        let sessions = appState.storageService.loadSessions(forChild: child.id)
        return sessions.filter {
            meditationIds.contains($0.meditationId) && $0.completedFully
        }.count
    }

    func skill(id: UUID) -> Skill? {
        appState.contentService.skill(id: id)
    }

    func practiceCount(for skillId: UUID) -> Int {
        guard let skill = skill(id: skillId) else { return 0 }
        return countPractices(for: skill)
    }

    func meditationForSkill(_ skillId: UUID) -> Meditation? {
        appState.contentService.allMeditations
            .first { $0.skillIds.contains(skillId) }
    }
}

struct SkillWithState: Identifiable {
    let skill: Skill
    let state: SkillCardState

    var id: UUID { skill.id }
}

enum SkillCardState {
    case locked
    case unlocked
    case learned(practiceCount: Int)

    var isAccessible: Bool {
        switch self {
        case .locked: return false
        case .unlocked, .learned: return true
        }
    }

    var practiceCount: Int {
        switch self {
        case .learned(let count): return count
        default: return 0
        }
    }
}
