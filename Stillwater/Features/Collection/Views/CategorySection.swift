import SwiftUI

struct CategorySection: View {
    let category: Meditation.Category
    let skills: [SkillWithState]
    let onSkillTap: (Skill) -> Void

    private var learnedCount: Int {
        skills.filter { $0.state.isAccessible }.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
            HStack {
                Image(systemName: category.iconName)
                    .font(.system(size: 16))
                    .foregroundStyle(category.color)

                Text(category.displayName.uppercased())
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Spacer()

                Text("\(learnedCount)/\(skills.count)")
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: StillwaterSpacing.sm) {
                    ForEach(skills) { skillWithState in
                        SkillCardView(
                            skill: skillWithState.skill,
                            state: skillWithState.state,
                            onTap: {
                                if skillWithState.state.isAccessible {
                                    onSkillTap(skillWithState.skill)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            }
        }
    }
}

#Preview {
    CategorySection(
        category: .breath,
        skills: [
            SkillWithState(
                skill: Skill(
                    id: UUID(),
                    name: "Balloon Breath",
                    description: "Deep breathing",
                    category: .breath,
                    iconName: "wind",
                    technique: "",
                    useWhen: "",
                    sortOrder: 1
                ),
                state: .learned(practiceCount: 5)
            ),
            SkillWithState(
                skill: Skill(
                    id: UUID(),
                    name: "Smell Flower",
                    description: "Gentle breathing",
                    category: .breath,
                    iconName: "leaf",
                    technique: "",
                    useWhen: "",
                    sortOrder: 2
                ),
                state: .unlocked
            ),
            SkillWithState(
                skill: Skill(
                    id: UUID(),
                    name: "Square Breath",
                    description: "Box breathing",
                    category: .breath,
                    iconName: "square",
                    technique: "",
                    useWhen: "",
                    sortOrder: 3
                ),
                state: .locked
            )
        ],
        onSkillTap: { _ in }
    )
}
