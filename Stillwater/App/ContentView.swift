import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if !appState.isContentLoaded {
                LoadingView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingContainerView()
            } else {
                MainAppView()
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.md) {
                MiloCharacter(mood: .breathing, size: .medium)

                Text("Stillwater")
                    .font(StillwaterFont.displayMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }
        }
    }
}

struct MainAppView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack(path: Binding(
            get: { appState.navigationPath },
            set: { appState.navigationPath = $0 }
        )) {
            HomeView()
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()
        case .meditationPreview(let id):
            if let meditation = appState.contentService.meditation(id: id) {
                MeditationPreviewView(meditation: meditation)
            } else {
                PlaceholderView(title: "Meditation not found")
            }
        case .meditationPlayer(let id):
            if let meditation = appState.contentService.meditation(id: id) {
                MeditationPlayerView(meditation: meditation)
            } else {
                PlaceholderView(title: "Meditation not found")
            }
        case .sessionComplete(let meditationId, let skillId, let feeling):
            SessionCompleteView(
                meditationId: meditationId,
                earnedSkillId: skillId,
                feeling: feeling
            )
        case .calmCards:
            CalmCardsView()
        case .cardDetail(let skillId):
            SkillDetailView(skillId: skillId)
        case .toolkit:
            ToolkitHomeView()
        case .toolkitProtocol(let feeling, let protocolId):
            ToolkitProtocolPlayerView(feeling: feeling, protocolId: protocolId)
        case .toolkitComplete(let feeling, let resultFeeling):
            ToolkitCompleteView(feeling: feeling, resultFeeling: resultFeeling)
        case .adventures:
            PlaceholderView(title: "Adventures")
        case .adventurePlayer:
            PlaceholderView(title: "Adventure")
        case .parentPIN:
            ParentPINEntryView()
        case .parentDashboard:
            ParentDashboardView()
        case .settings:
            SettingsView()
        case .editProfile:
            EditProfileView()
        case .changePIN:
            ChangePINView()
        case .about:
            AboutView()
        default:
            PlaceholderView(title: "Coming Soon")
        }
    }
}

// MARK: - Placeholder Views

struct PlaceholderView: View {
    let title: String
    @Environment(AppState.self) private var appState

    var body: some View {
        ScreenContainer {
            VStack(spacing: StillwaterSpacing.lg) {
                MiloCharacter(mood: .neutral, size: .large)

                Text(title)
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("Coming soon...")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)

                if !appState.navigationPath.isEmpty {
                    SecondaryButton("Go Back", icon: "chevron.left") {
                        appState.navigateBack()
                    }
                    .frame(width: 200)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
