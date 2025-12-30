import SwiftUI

struct CalmCardsView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel: CalmCardsViewModel?

    var body: some View {
        ScrollView {
            VStack(spacing: StillwaterSpacing.lg) {
                progressHeader

                ForEach(Meditation.Category.allCases, id: \.self) { category in
                    if let skills = viewModel?.skillsByCategory[category], !skills.isEmpty {
                        CategorySection(
                            category: category,
                            skills: skills,
                            onSkillTap: { skill in
                                appState.navigate(to: .cardDetail(skillId: skill.id))
                            }
                        )
                    }
                }

                Spacer(minLength: StillwaterSpacing.xxl)
            }
            .padding(.top, StillwaterSpacing.md)
        }
        .background(StillwaterColors.bgPrimary.ignoresSafeArea())
        .navigationTitle("Calm Cards")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                viewModel = CalmCardsViewModel(appState: appState)
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: StillwaterSpacing.sm) {
            HStack {
                Text("Your collection")
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)

                Spacer()

                Text("\(viewModel?.learnedSkillsCount ?? 0) of \(viewModel?.totalSkills ?? 0) skills")
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }

            CollectionProgressBar(
                current: viewModel?.learnedSkillsCount ?? 0,
                total: viewModel?.totalSkills ?? 1
            )
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }
}

#Preview {
    NavigationStack {
        CalmCardsView()
            .environment(AppState())
    }
}
