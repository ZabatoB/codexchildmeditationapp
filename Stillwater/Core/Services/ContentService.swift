import Foundation
import Observation

// MARK: - Content Error
enum ContentError: Error {
    case fileNotFound(String)
    case decodingFailed(String, Error)
    case notLoaded
}

// MARK: - Content Wrapper Types (for JSON parsing)
private struct MeditationsWrapper: Codable {
    let meditations: [Meditation]
}

private struct SkillsWrapper: Codable {
    let skills: [Skill]
}

private struct AdventuresWrapper: Codable {
    let adventures: [Adventure]
}

private struct ProtocolsWrapper: Codable {
    let protocols: [ToolkitProtocol]
}

// MARK: - Content Service Protocol
protocol ContentServiceProtocol {
    // Loading
    var isLoaded: Bool { get }
    func loadAllContent() throws

    // Meditations
    var allMeditations: [Meditation] { get }
    func meditation(id: UUID) -> Meditation?
    func meditations(for ageRange: ChildProfile.AgeRange) -> [Meditation]
    func meditations(for category: Meditation.Category) -> [Meditation]
    func unlockedMeditations(sessionCount: Int) -> [Meditation]
    func nextRecommendedMeditation(for child: ChildProfile, completedMeditationIds: [UUID]) -> Meditation?

    // Skills
    var allSkills: [Skill] { get }
    func skill(id: UUID) -> Skill?
    func skills(for category: Meditation.Category) -> [Skill]
    func skills(ids: [UUID]) -> [Skill]

    // Adventures
    var allAdventures: [Adventure] { get }
    func adventure(id: UUID) -> Adventure?
    func unlockedAdventures(sessionCount: Int) -> [Adventure]

    // Toolkit
    var allProtocols: [ToolkitProtocol] { get }
    func toolkitProtocol(for feeling: Feeling) -> ToolkitProtocol?

    // Config
    var appConfig: AppConfig { get }
}

// MARK: - Content Service Implementation
@Observable
final class ContentService: ContentServiceProtocol {

    // MARK: - Properties
    private(set) var isLoaded = false

    private var _meditations: [Meditation] = []
    private var _skills: [Skill] = []
    private var _adventures: [Adventure] = []
    private var _protocols: [ToolkitProtocol] = []
    private var _appConfig: AppConfig?

    private let decoder: JSONDecoder

    // MARK: - Initialization
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Loading
    func loadAllContent() throws {
        let meditationsWrapper: MeditationsWrapper = try loadBundledJSON("meditations")
        _meditations = meditationsWrapper.meditations.sorted { $0.sortOrder < $1.sortOrder }

        let skillsWrapper: SkillsWrapper = try loadBundledJSON("skills")
        _skills = skillsWrapper.skills.sorted { $0.sortOrder < $1.sortOrder }

        let adventuresWrapper: AdventuresWrapper = try loadBundledJSON("adventures")
        _adventures = adventuresWrapper.adventures.sorted { $0.sortOrder < $1.sortOrder }

        let protocolsWrapper: ProtocolsWrapper = try loadBundledJSON("toolkit-protocols")
        _protocols = protocolsWrapper.protocols

        _appConfig = try loadBundledJSON("app-config")

        isLoaded = true
    }

    private func loadBundledJSON<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw ContentError.fileNotFound(filename)
        }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ContentError.decodingFailed(filename, error)
        }
    }

    // MARK: - Meditations
    var allMeditations: [Meditation] {
        _meditations
    }

    func meditation(id: UUID) -> Meditation? {
        _meditations.first { $0.id == id }
    }

    func meditations(for ageRange: ChildProfile.AgeRange) -> [Meditation] {
        _meditations.filter { $0.ageRanges.contains(ageRange) }
    }

    func meditations(for category: Meditation.Category) -> [Meditation] {
        _meditations.filter { $0.category == category }
    }

    func unlockedMeditations(sessionCount: Int) -> [Meditation] {
        _meditations.filter { meditation in
            if !meditation.isLocked { return true }
            guard let required = meditation.unlockAfterSessions else { return true }
            return sessionCount >= required
        }
    }

    func nextRecommendedMeditation(for child: ChildProfile, completedMeditationIds: [UUID]) -> Meditation? {
        let available = meditations(for: child.ageRange)
            .filter { !$0.isLocked || ($0.unlockAfterSessions ?? 0) <= completedMeditationIds.count }

        let notCompleted = available.filter { !completedMeditationIds.contains($0.id) }
        if let first = notCompleted.first {
            return first
        }

        return available.first
    }

    // MARK: - Skills
    var allSkills: [Skill] {
        _skills
    }

    func skill(id: UUID) -> Skill? {
        _skills.first { $0.id == id }
    }

    func skills(for category: Meditation.Category) -> [Skill] {
        _skills.filter { $0.category == category }
    }

    func skills(ids: [UUID]) -> [Skill] {
        _skills.filter { ids.contains($0.id) }
    }

    // MARK: - Adventures
    var allAdventures: [Adventure] {
        _adventures
    }

    func adventure(id: UUID) -> Adventure? {
        _adventures.first { $0.id == id }
    }

    func unlockedAdventures(sessionCount: Int) -> [Adventure] {
        _adventures.filter { adventure in
            if !adventure.isLocked { return true }
            guard let required = adventure.unlockAfterSessions else { return true }
            return sessionCount >= required
        }
    }

    // MARK: - Toolkit Protocols
    var allProtocols: [ToolkitProtocol] {
        _protocols
    }

    func toolkitProtocol(for feeling: Feeling) -> ToolkitProtocol? {
        _protocols.first { $0.feeling == feeling }
    }

    // MARK: - Config
    var appConfig: AppConfig {
        _appConfig ?? AppConfig.default
    }
}

// MARK: - Default Config
extension AppConfig {
    static let `default` = AppConfig(
        appName: "Stillwater",
        version: "1.0.0",
        minimumAge: 4,
        maximumAge: 12,
        defaultSessionLengthMinutes: 5,
        maxSessionLengthMinutes: 15,
        streakResetHours: 36,
        gardenGrowthPerSession: 0.05,
        maxGardenGrowth: 1.0,
        sessionsToUnlockToolkit: 1,
        skillLearningThreshold: 3,
        defaultAgeRange: "7-9",
        miloMessages: MiloMessages(
            greeting: ["Hi! Ready to practice?"],
            encouragement: ["You're doing great!"],
            return: ["Welcome back!"],
            completion: ["Great job!"],
            gardenGrowth: ["Your garden is growing!"],
            streakCelebration: ["{streak} days!"],
            firstTime: ["Welcome!"]
        ),
        feelingLabels: [:],
        categoryLabels: [:],
        ageRangeLabels: [:]
    )
}
