import Foundation
import Observation

// MARK: - Storage Keys
enum StorageKey {
    static let hasCompletedOnboarding = "stillwater.hasCompletedOnboarding"
    static let parentPIN = "stillwater.parentPIN"
    static let currentChildId = "stillwater.currentChildId"
    static let settings = "stillwater.settings"
    static let lastLaunchDate = "stillwater.lastLaunchDate"
}

// MARK: - Storage File Names
enum StorageFile {
    static let children = "children.json"
    static let sessions = "sessions.json"
    static let toolkitUsage = "toolkit-usage.json"
}

// MARK: - Storage Service Protocol
protocol StorageServiceProtocol {
    // Settings (UserDefaults)
    var hasCompletedOnboarding: Bool { get set }
    var parentPIN: String? { get set }
    var currentChildId: UUID? { get set }
    func loadSettings() -> AppSettings
    func saveSettings(_ settings: AppSettings)

    // Child Profiles (JSON file)
    func loadChildProfiles() -> [ChildProfile]
    func saveChildProfile(_ profile: ChildProfile)
    func updateChildProfile(_ profile: ChildProfile)
    func deleteChildProfile(id: UUID)
    func getChildProfile(id: UUID) -> ChildProfile?

    // Sessions (JSON file)
    func loadAllSessions() -> [Session]
    func loadSessions(forChild childId: UUID) -> [Session]
    func saveSession(_ session: Session)
    func getRecentSessions(forChild childId: UUID, limit: Int) -> [Session]
    func deleteSessions(forChild childId: UUID)

    // Toolkit Usage
    func loadAllToolkitUsage() -> [ToolkitUsage]
    func loadToolkitUsage(forChild childId: UUID) -> [ToolkitUsage]
    func saveToolkitUsage(_ usage: ToolkitUsage)
    func deleteToolkitUsage(forChild childId: UUID)

    // Data Management
    func clearAllData()
}

// MARK: - Storage Service Implementation
@Observable
final class StorageService: StorageServiceProtocol {

    // MARK: - Properties
    private let defaults = UserDefaults.standard
    private let fileManager = FileManager.default
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    // Cached data
    private var cachedChildren: [ChildProfile]?
    private var cachedSessions: [Session]?
    @ObservationIgnored private var cachedToolkitUsage: [ToolkitUsage]?

    // MARK: - Initialization
    init() {
        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - File Paths
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for filename: String) -> URL {
        documentsDirectory.appendingPathComponent(filename)
    }

    // MARK: - UserDefaults Properties
    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: StorageKey.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: StorageKey.hasCompletedOnboarding) }
    }

    var parentPIN: String? {
        get { defaults.string(forKey: StorageKey.parentPIN) }
        set { defaults.set(newValue, forKey: StorageKey.parentPIN) }
    }

    var currentChildId: UUID? {
        get {
            guard let string = defaults.string(forKey: StorageKey.currentChildId) else { return nil }
            return UUID(uuidString: string)
        }
        set {
            defaults.set(newValue?.uuidString, forKey: StorageKey.currentChildId)
        }
    }

    // MARK: - Settings
    func loadSettings() -> AppSettings {
        guard let data = defaults.data(forKey: StorageKey.settings),
              let settings = try? decoder.decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return settings
    }

    func saveSettings(_ settings: AppSettings) {
        guard let data = try? encoder.encode(settings) else { return }
        defaults.set(data, forKey: StorageKey.settings)
    }

    // MARK: - Child Profiles
    func loadChildProfiles() -> [ChildProfile] {
        if let cached = cachedChildren {
            return cached
        }

        let url = fileURL(for: StorageFile.children)

        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let profiles = try? decoder.decode([ChildProfile].self, from: data) else {
            return []
        }

        cachedChildren = profiles
        return profiles
    }

    func saveChildProfile(_ profile: ChildProfile) {
        var profiles = loadChildProfiles()

        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
        } else {
            profiles.append(profile)
        }

        saveChildProfiles(profiles)
    }

    func updateChildProfile(_ profile: ChildProfile) {
        saveChildProfile(profile)
    }

    func deleteChildProfile(id: UUID) {
        var profiles = loadChildProfiles()
        profiles.removeAll { $0.id == id }
        saveChildProfiles(profiles)

        var sessions = loadAllSessions()
        sessions.removeAll { $0.childId == id }
        saveAllSessions(sessions)

        if currentChildId == id {
            currentChildId = nil
        }
    }

    func getChildProfile(id: UUID) -> ChildProfile? {
        loadChildProfiles().first { $0.id == id }
    }

    private func saveChildProfiles(_ profiles: [ChildProfile]) {
        cachedChildren = profiles

        let url = fileURL(for: StorageFile.children)
        guard let data = try? encoder.encode(profiles) else { return }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save child profiles: \(error)")
        }
    }

    // MARK: - Sessions
    func loadAllSessions() -> [Session] {
        if let cached = cachedSessions {
            return cached
        }

        let url = fileURL(for: StorageFile.sessions)

        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let sessions = try? decoder.decode([Session].self, from: data) else {
            return []
        }

        cachedSessions = sessions
        return sessions
    }

    func loadSessions(forChild childId: UUID) -> [Session] {
        loadAllSessions().filter { $0.childId == childId }
    }

    func saveSession(_ session: Session) {
        var sessions = loadAllSessions()

        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }

        saveAllSessions(sessions)
    }

    func getRecentSessions(forChild childId: UUID, limit: Int) -> [Session] {
        let sessions = loadSessions(forChild: childId)
        let sorted = sessions.sorted { ($0.completedAt ?? $0.startedAt) > ($1.completedAt ?? $1.startedAt) }
        return Array(sorted.prefix(limit))
    }

    func deleteSessions(forChild childId: UUID) {
        var sessions = loadAllSessions()
        sessions.removeAll { $0.childId == childId }
        saveAllSessions(sessions)
    }

    private func saveAllSessions(_ sessions: [Session]) {
        cachedSessions = sessions

        let url = fileURL(for: StorageFile.sessions)
        guard let data = try? encoder.encode(sessions) else { return }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save sessions: \(error)")
        }
    }

    // MARK: - Toolkit Usage
    func loadAllToolkitUsage() -> [ToolkitUsage] {
        if let cached = cachedToolkitUsage {
            return cached
        }

        let url = fileURL(for: StorageFile.toolkitUsage)

        guard fileManager.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let usage = try? decoder.decode([ToolkitUsage].self, from: data) else {
            return []
        }

        cachedToolkitUsage = usage
        return usage
    }

    func loadToolkitUsage(forChild childId: UUID) -> [ToolkitUsage] {
        loadAllToolkitUsage().filter { $0.childId == childId }
    }

    func saveToolkitUsage(_ usage: ToolkitUsage) {
        var allUsage = loadAllToolkitUsage()

        if let index = allUsage.firstIndex(where: { $0.id == usage.id }) {
            allUsage[index] = usage
        } else {
            allUsage.append(usage)
        }

        saveAllToolkitUsage(allUsage)
    }

    func deleteToolkitUsage(forChild childId: UUID) {
        var allUsage = loadAllToolkitUsage()
        allUsage.removeAll { $0.childId == childId }
        saveAllToolkitUsage(allUsage)
    }

    private func saveAllToolkitUsage(_ usage: [ToolkitUsage]) {
        cachedToolkitUsage = usage

        let url = fileURL(for: StorageFile.toolkitUsage)
        guard let data = try? encoder.encode(usage) else { return }

        do {
            try data.write(to: url, options: .atomic)
        } catch {
            print("Failed to save toolkit usage: \(error)")
        }
    }

    // MARK: - Data Management
    func clearAllData() {
        defaults.removeObject(forKey: StorageKey.hasCompletedOnboarding)
        defaults.removeObject(forKey: StorageKey.parentPIN)
        defaults.removeObject(forKey: StorageKey.currentChildId)
        defaults.removeObject(forKey: StorageKey.settings)
        defaults.removeObject(forKey: StorageKey.lastLaunchDate)

        try? fileManager.removeItem(at: fileURL(for: StorageFile.children))
        try? fileManager.removeItem(at: fileURL(for: StorageFile.sessions))
        try? fileManager.removeItem(at: fileURL(for: StorageFile.toolkitUsage))

        cachedChildren = nil
        cachedSessions = nil
        cachedToolkitUsage = nil
    }

    // MARK: - Cache Invalidation
    func invalidateCache() {
        cachedChildren = nil
        cachedSessions = nil
    }
}
