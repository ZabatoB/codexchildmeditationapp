import Observation
import SwiftUI

@Observable
final class AppState {
    // MARK: - Services
    let storageService: StorageService
    let contentService: ContentService
    let progressService: ProgressService

    // MARK: - Navigation
    var currentRoute: AppRoute = .onboarding
    var navigationPath = NavigationPath()

    // MARK: - User State
    var currentChild: ChildProfile?
    var settings: AppSettings

    // MARK: - Mode
    var isParentMode: Bool = false
    var isNightMode: Bool = false

    // MARK: - Content Loaded State
    var isContentLoaded: Bool = false
    var contentLoadError: Error?

    // MARK: - Initialization
    init() {
        storageService = StorageService()
        contentService = ContentService()

        progressService = ProgressService(
            storageService: storageService,
            contentService: contentService
        )

        settings = storageService.loadSettings()

        if let childId = storageService.currentChildId {
            currentChild = storageService.getChildProfile(id: childId)
        }

        currentRoute = storageService.hasCompletedOnboarding ? .home : .onboarding
    }

    // MARK: - Content Loading
    func loadContent() {
        do {
            try contentService.loadAllContent()
            isContentLoaded = true
        } catch {
            contentLoadError = error
            print("Failed to load content: \(error)")
        }
    }

    // MARK: - Computed Properties
    var hasCompletedOnboarding: Bool {
        storageService.hasCompletedOnboarding
    }

    var isToolkitUnlocked: Bool {
        guard let child = currentChild else { return false }
        let sessionCount = progressService.sessionCount(for: child)
        return sessionCount >= contentService.appConfig.sessionsToUnlockToolkit
    }

    // MARK: - Navigation Actions
    func navigate(to route: AppRoute) {
        navigationPath.append(route)
    }

    func navigateBack() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }

    func navigateToRoot() {
        navigationPath = NavigationPath()
        currentRoute = .home
    }

    // MARK: - Onboarding Actions
    func completeOnboarding(with child: ChildProfile, pin: String) {
        storageService.saveChildProfile(child)

        storageService.currentChildId = child.id
        currentChild = child

        storageService.parentPIN = pin

        storageService.hasCompletedOnboarding = true

        settings.hasCompletedOnboarding = true
        settings.currentChildId = child.id
        storageService.saveSettings(settings)

        currentRoute = .home
        navigationPath = NavigationPath()
    }

    // MARK: - Child Profile Actions
    func setCurrentChild(_ child: ChildProfile) {
        currentChild = child
        storageService.currentChildId = child.id
        settings.currentChildId = child.id
        storageService.saveSettings(settings)
    }

    func updateCurrentChild(_ child: ChildProfile) {
        currentChild = child
        storageService.updateChildProfile(child)
    }

    // MARK: - Session Actions
    func recordSession(_ session: Session) {
        guard var child = currentChild else { return }
        progressService.recordSession(session, for: &child)
        currentChild = child
    }

    // MARK: - Data Management
    func resetAllData() {
        storageService.clearAllData()
        currentChild = nil
        settings = AppSettings()
        currentRoute = .onboarding
        navigationPath = NavigationPath()
    }
}

// MARK: - App Routes
enum AppRoute: Hashable {
    // Onboarding
    case onboarding
    case parentSetup
    case childOnboarding
    case firstBreath

    // Main
    case home

    // Meditation
    case meditationPreview(meditationId: UUID)
    case meditationPlayer(meditationId: UUID)
    case sessionComplete(meditationId: UUID, earnedSkillId: UUID?, feeling: Feeling?)

    // Collection
    case calmCards
    case cardDetail(skillId: UUID)

    // Toolkit
    case toolkit
    case toolkitProtocol(feeling: Feeling, protocolId: UUID)
    case toolkitComplete(feeling: Feeling, resultFeeling: Feeling?)

    // Adventures
    case adventures
    case adventurePlayer(adventureId: UUID)

    // Parent
    case parentPIN
    case parentDashboard
    case settings
    case editProfile
    case changePIN
    case about
}
