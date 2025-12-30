import SwiftUI

struct SkillCard: View {
    let skill: Skill
    let isLearned: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: StillwaterSpacing.xs) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(isLearned ? skill.category.color.opacity(0.2) : StillwaterColors.bgSecondary)
                        .frame(width: 60, height: 60)

                    if isLearned {
                        Image(systemName: skill.iconName)
                            .font(.system(size: 24))
                            .foregroundStyle(skill.category.color)
                    } else {
                        Image(systemName: StillwaterIcon.lock)
                            .font(.system(size: 20))
                            .foregroundStyle(StillwaterColors.textTertiary)
                    }
                }

                // Title
                Text(skill.name)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(isLearned ? StillwaterColors.textPrimary : StillwaterColors.textTertiary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
        }
        .disabled(!isLearned)
    }
}

#Preview {
    HStack(spacing: 20) {
        SkillCard(
            skill: Skill(
                id: UUID(),
                name: "Balloon Breath",
                description: "Deep belly breathing",
                category: .breath,
                iconName: "wind",
                technique: "",
                useWhen: "",
                sortOrder: 1
            ),
            isLearned: true,
            onTap: {}
        )

        SkillCard(
            skill: Skill(
                id: UUID(),
                name: "Sound Safari",
                description: "Attention through listening",
                category: .mind,
                iconName: "ear",
                technique: "",
                useWhen: "",
                sortOrder: 2
            ),
            isLearned: false,
            onTap: {}
        )
    }
    .padding()
}
