import SwiftUI

struct SkillDetailView: View {
    @Environment(AppState.self) private var appState
    let skillId: UUID

    @State private var skill: Skill?
    @State private var practiceCount: Int = 0
    @State private var meditation: Meditation?

    var body: some View {
        ScrollView {
            VStack(spacing: StillwaterSpacing.xl) {
                headerSection

                if let skill = skill {
                    descriptionSection(skill)
                    techniqueSection(skill)
                    whenToUseSection(skill)
                }

                Spacer(minLength: StillwaterSpacing.xxl)
            }
            .padding(.top, StillwaterSpacing.lg)
        }
        .background(StillwaterColors.bgPrimary.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            practiceButton
        }
        .onAppear {
            loadSkillData()
        }
    }

    private var headerSection: some View {
        VStack(spacing: StillwaterSpacing.md) {
            ZStack {
                Circle()
                    .fill((skill?.category.color ?? StillwaterColors.sage).opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: skill?.iconName ?? "questionmark")
                    .font(.system(size: 44))
                    .foregroundStyle(skill?.category.color ?? StillwaterColors.sage)
            }

            Text(skill?.name ?? "Loading...")
                .font(StillwaterFont.displaySmall)
                .foregroundStyle(StillwaterColors.textPrimary)

            HStack(spacing: StillwaterSpacing.md) {
                Label(skill?.category.displayName ?? "", systemImage: skill?.category.iconName ?? "")
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(skill?.category.color ?? StillwaterColors.textSecondary)

                if practiceCount > 0 {
                    Text("•")
                        .foregroundStyle(StillwaterColors.textTertiary)

                    Text("Practiced \(practiceCount) \(practiceCount == 1 ? "time" : "times")")
                        .font(StillwaterFont.labelSmall)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private func descriptionSection(_ skill: Skill) -> some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("What is it?")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)

            Text(skill.description)
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
                .lineSpacing(StillwaterLineSpacing.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private func techniqueSection(_ skill: Skill) -> some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("How to do it")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)

            Text(skill.technique)
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
                .lineSpacing(StillwaterLineSpacing.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(StillwaterSpacing.md)
        .background(StillwaterColors.bgTertiary)
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private func whenToUseSection(_ skill: Skill) -> some View {
        let uses = skill.useWhen.components(separatedBy: ", ")

        return VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            Text("When to use it")
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)

            VStack(alignment: .leading, spacing: StillwaterSpacing.xs) {
                ForEach(uses, id: \.self) { use in
                    HStack(alignment: .top, spacing: StillwaterSpacing.xs) {
                        Circle()
                            .fill(skill.category.color)
                            .frame(width: 6, height: 6)
                            .offset(y: 6)

                        Text(use.capitalized)
                            .font(StillwaterFont.bodyMedium)
                            .foregroundStyle(StillwaterColors.textSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var practiceButton: some View {
        PrimaryButton("Practice This Now", icon: StillwaterIcon.play) {
            if let meditation = meditation {
                appState.navigate(to: .meditationPreview(meditationId: meditation.id))
            }
        }
        .disabled(meditation == nil)
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        .padding(.vertical, StillwaterSpacing.md)
        .background(StillwaterColors.bgPrimary)
    }

    private func loadSkillData() {
        skill = appState.contentService.skill(id: skillId)

        if let skill = skill {
            meditation = appState.contentService.allMeditations
                .first { $0.skillIds.contains(skill.id) }

            if let child = appState.currentChild {
                let meditationIds = appState.contentService.allMeditations
                    .filter { $0.skillIds.contains(skill.id) }
                    .map { $0.id }

                let sessions = appState.storageService.loadSessions(forChild: child.id)
                practiceCount = sessions.filter {
                    meditationIds.contains($0.meditationId) && $0.completedFully
                }.count
            }
        }
    }
}

#Preview {
    NavigationStack {
        SkillDetailView(skillId: UUID())
            .environment(AppState())
    }
}
