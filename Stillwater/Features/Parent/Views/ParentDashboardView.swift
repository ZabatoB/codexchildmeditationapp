import SwiftUI

struct ParentDashboardView: View {
    @Environment(AppState.self) private var appState

    @State private var viewModel: ParentDashboardViewModel?

    var body: some View {
        ScrollView {
            VStack(spacing: StillwaterSpacing.lg) {
                childHeaderCard
                weeklyStatsSection
                emotionalPatternsSection
                skillsProgressSection

                Spacer(minLength: StillwaterSpacing.xxl)
            }
            .padding(.top, StillwaterSpacing.md)
        }
        .background(StillwaterColors.bgSecondary.ignoresSafeArea())
        .navigationTitle("Parent Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Exit") {
                    appState.navigateToRoot()
                }
                .foregroundStyle(StillwaterColors.textSecondary)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.navigate(to: .settings)
                } label: {
                    Image(systemName: StillwaterIcon.settings)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ParentDashboardViewModel(appState: appState)
            }
        }
    }

    private var childHeaderCard: some View {
        ContentCard {
            HStack {
                VStack(alignment: .leading, spacing: StillwaterSpacing.xxs) {
                    Text("\(viewModel?.childName ?? "Child")'s Progress")
                        .font(StillwaterFont.headlineSmall)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text(lastPracticedText)
                        .font(StillwaterFont.labelSmall)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }

                Spacer()

                Circle()
                    .fill(StillwaterColors.sage.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text("🧒")
                            .font(.system(size: 24))
                    }
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var lastPracticedText: String {
        guard let lastDate = viewModel?.lastPracticeDate else {
            return "No sessions yet"
        }

        if Calendar.current.isDateInToday(lastDate) {
            return "Last practiced: Today"
        } else if Calendar.current.isDateInYesterday(lastDate) {
            return "Last practiced: Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Last practiced: \(formatter.string(from: lastDate))"
        }
    }

    private var weeklyStatsSection: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("This Week")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            ContentCard {
                VStack(spacing: StillwaterSpacing.md) {
                    HStack(spacing: 0) {
                        DashboardStatItem(
                            icon: "flame.fill",
                            value: "\(viewModel?.weeklyData.currentStreak ?? 0)",
                            label: "day streak",
                            color: StillwaterColors.sunrise
                        )

                        DashboardStatItem(
                            icon: "clock.fill",
                            value: "\(viewModel?.weeklyData.totalMinutes ?? 0)",
                            label: "min practiced",
                            color: StillwaterColors.sky
                        )

                        DashboardStatItem(
                            icon: "square.stack.fill",
                            value: "\(viewModel?.weeklyData.skillsLearnedThisWeek ?? 0)",
                            label: "skills learned",
                            color: StillwaterColors.sage
                        )
                    }

                    WeeklyActivityChart(days: viewModel?.weeklyData.days ?? [])
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        }
    }

    private var emotionalPatternsSection: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("Emotional Patterns")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            ContentCard {
                VStack(alignment: .leading, spacing: StillwaterSpacing.md) {
                    if let mostUsed = viewModel?.emotionalInsights.mostUsedToolkitFeeling {
                        HStack {
                            Text("Most used toolkit:")
                                .font(StillwaterFont.bodySmall)
                                .foregroundStyle(StillwaterColors.textSecondary)

                            Text("\(mostUsed.emoji) \(mostUsed.displayName)")
                                .font(StillwaterFont.labelMedium)
                                .foregroundStyle(StillwaterColors.textPrimary)

                            Text("(\(viewModel?.emotionalInsights.toolkitUsageByFeeling[mostUsed] ?? 0) times)")
                                .font(StillwaterFont.caption)
                                .foregroundStyle(StillwaterColors.textTertiary)
                        }
                    } else {
                        Text("No toolkit usage yet")
                            .font(StillwaterFont.bodySmall)
                            .foregroundStyle(StillwaterColors.textSecondary)
                    }

                    VStack(alignment: .leading, spacing: StillwaterSpacing.xs) {
                        Text("After practice:")
                            .font(StillwaterFont.bodySmall)
                            .foregroundStyle(StillwaterColors.textSecondary)

                        HStack(spacing: StillwaterSpacing.sm) {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(StillwaterColors.bgTertiary)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(StillwaterColors.sage)
                                        .frame(width: geometry.size.width * (viewModel?.emotionalInsights.postSessionCalmerRate ?? 0))
                                }
                            }
                            .frame(height: 8)

                            Text("\(Int((viewModel?.emotionalInsights.postSessionCalmerRate ?? 0) * 100))% feel calmer")
                                .font(StillwaterFont.labelSmall)
                                .foregroundStyle(StillwaterColors.textPrimary)
                                .fixedSize()
                        }
                    }
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        }
    }

    private var skillsProgressSection: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("Skills Progress")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            ContentCard {
                VStack(spacing: StillwaterSpacing.sm) {
                    ForEach(Meditation.Category.allCases, id: \.self) { category in
                        if let progress = viewModel?.skillProgress.byCategory[category] {
                            SkillCategoryRow(
                                category: category,
                                learned: progress.learned,
                                total: progress.total
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        }
    }
}

struct DashboardStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: StillwaterSpacing.xxs) {
            HStack(spacing: StillwaterSpacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)

                Text(value)
                    .font(StillwaterFont.headlineMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }

            Text(label)
                .font(StillwaterFont.caption)
                .foregroundStyle(StillwaterColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SkillCategoryRow: View {
    let category: Meditation.Category
    let learned: Int
    let total: Int

    var body: some View {
        HStack {
            Image(systemName: category.iconName)
                .font(.system(size: 14))
                .foregroundStyle(category.color)
                .frame(width: 24)

            Text(category.displayName)
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            Spacer()

            Text("\(learned)/\(total)")
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        ParentDashboardView()
            .environment(AppState())
    }
}
