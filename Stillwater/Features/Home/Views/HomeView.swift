import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel: HomeViewModel?

    var body: some View {
        ScrollView {
            VStack(spacing: StillwaterSpacing.lg) {
                headerSection
                gardenSection
                todaysPracticeSection
                quickStatsSection
                exploreSection

                Spacer(minLength: StillwaterSpacing.xxl)
            }
            .padding(.top, StillwaterSpacing.md)
        }
        .background(StillwaterGradients.daytime.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            if viewModel == nil {
                viewModel = HomeViewModel(appState: appState)
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: StillwaterSpacing.xxs) {
                Text(viewModel?.greetingText ?? "Hi!")
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text(viewModel?.subtitleText ?? "Ready to practice?")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }

            Spacer()

            Button {
                appState.navigate(to: .parentPIN)
            } label: {
                Image(systemName: StillwaterIcon.settings)
                    .font(.system(size: 22))
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var gardenSection: some View {
        InteractiveGardenView(
            gardenState: viewModel?.gardenState ?? GardenState(),
            totalSessions: viewModel?.totalSessions ?? 0
        )
        .frame(height: 140)
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var todaysPracticeSection: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            SectionHeader("Today's Practice")
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            if let meditation = viewModel?.recommendedMeditation {
                TodaysPracticeCard(
                    meditation: meditation,
                    isCompleted: viewModel?.hasCompletedToday ?? false,
                    nextUnlock: viewModel?.nextUnlock,
                    onPlay: {
                        appState.navigate(to: .meditationPreview(meditationId: meditation.id))
                    }
                )
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            } else {
                AllDoneCard()
                    .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            }
        }
    }

    private var quickStatsSection: some View {
        QuickStatsRow(
            streak: viewModel?.currentStreak ?? 0,
            minutes: viewModel?.totalMinutesThisWeek ?? 0,
            skills: viewModel?.skillsLearnedCount ?? 0
        )
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var exploreSection: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            SectionHeader("Explore")
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            ExploreGrid(
                isToolkitUnlocked: viewModel?.isToolkitUnlocked ?? false,
                onCalmCardsTap: {
                    appState.navigate(to: .calmCards)
                },
                onToolkitTap: {
                    if viewModel?.isToolkitUnlocked == true {
                        appState.navigate(to: .toolkit)
                    }
                },
                onAdventuresTap: {
                    appState.navigate(to: .adventures)
                }
            )
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        }
    }
}

struct AllDoneCard: View {
    var body: some View {
        ContentCard {
            HStack(spacing: StillwaterSpacing.md) {
                MiloCharacter(mood: .happy, size: .small)

                VStack(alignment: .leading, spacing: StillwaterSpacing.xxs) {
                    Text("Great job today!")
                        .font(StillwaterFont.headlineSmall)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text("Come back tomorrow for more practice.")
                        .font(StillwaterFont.bodySmall)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(AppState())
}
