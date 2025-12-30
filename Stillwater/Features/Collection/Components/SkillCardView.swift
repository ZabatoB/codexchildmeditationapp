import SwiftUI

struct SkillCardView: View {
    let skill: Skill
    let state: SkillCardState
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: StillwaterSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(backgroundColor)
                        .frame(width: 64, height: 64)

                    if case .locked = state {
                        Image(systemName: StillwaterIcon.lock)
                            .font(.system(size: 22))
                            .foregroundStyle(StillwaterColors.textTertiary)
                    } else {
                        Image(systemName: skill.iconName)
                            .font(.system(size: 26))
                            .foregroundStyle(skill.category.color)
                    }

                    if case .learned = state {
                        Circle()
                            .fill(StillwaterColors.sage)
                            .frame(width: 20, height: 20)
                            .overlay {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                            .offset(x: 22, y: -22)
                    }
                }

                Text(skill.name)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)

                if case .learned(let count) = state, count > 0 {
                    Text("\(count)x")
                        .font(StillwaterFont.caption)
                        .foregroundStyle(StillwaterColors.textTertiary)
                }
            }
            .frame(width: 90)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .disabled(!state.isAccessible)
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            withAnimation(StillwaterAnimation.quickEase) {
                isPressed = pressing
            }
        }, perform: {})
    }

    private var backgroundColor: Color {
        switch state {
        case .locked:
            return StillwaterColors.bgTertiary
        case .unlocked, .learned:
            return skill.category.color.opacity(0.15)
        }
    }

    private var textColor: Color {
        switch state {
        case .locked:
            return StillwaterColors.textTertiary
        case .unlocked, .learned:
            return StillwaterColors.textPrimary
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        SkillCardView(
            skill: Skill(
                id: UUID(),
                name: "Balloon Breath",
                description: "",
                category: .breath,
                iconName: "wind",
                technique: "",
                useWhen: "",
                sortOrder: 1
            ),
            state: .learned(practiceCount: 5),
            onTap: {}
        )

        SkillCardView(
            skill: Skill(
                id: UUID(),
                name: "Squeeze Let Go",
                description: "",
                category: .body,
                iconName: "hand.raised",
                technique: "",
                useWhen: "",
                sortOrder: 2
            ),
            state: .unlocked,
            onTap: {}
        )

        SkillCardView(
            skill: Skill(
                id: UUID(),
                name: "Sound Safari",
                description: "",
                category: .mind,
                iconName: "ear",
                technique: "",
                useWhen: "",
                sortOrder: 3
            ),
            state: .locked,
            onTap: {}
        )
    }
    .padding()
}
