import SwiftUI

struct ExploreGrid: View {
    let isToolkitUnlocked: Bool
    let onCalmCardsTap: () -> Void
    let onToolkitTap: () -> Void
    let onAdventuresTap: () -> Void

    var body: some View {
        HStack(spacing: StillwaterSpacing.sm) {
            ExploreButton(
                title: "Calm Cards",
                icon: StillwaterIcon.cards,
                color: StillwaterColors.sage,
                isLocked: false,
                action: onCalmCardsTap
            )

            ExploreButton(
                title: "Toolkit",
                icon: StillwaterIcon.toolkit,
                color: StillwaterColors.sky,
                isLocked: !isToolkitUnlocked,
                action: onToolkitTap
            )

            ExploreButton(
                title: "Adventures",
                icon: StillwaterIcon.adventure,
                color: StillwaterColors.lavender,
                isLocked: false,
                action: onAdventuresTap
            )
        }
    }
}

struct ExploreButton: View {
    let title: String
    let icon: String
    let color: Color
    let isLocked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            if !isLocked {
                action()
            }
        }) {
            VStack(spacing: StillwaterSpacing.xs) {
                ZStack {
                    Circle()
                        .fill(isLocked ? StillwaterColors.bgTertiary : color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    if isLocked {
                        Image(systemName: StillwaterIcon.lock)
                            .font(.system(size: 20))
                            .foregroundStyle(StillwaterColors.textTertiary)
                    } else {
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundStyle(color)
                    }
                }

                Text(title)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(isLocked ? StillwaterColors.textTertiary : StillwaterColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, StillwaterSpacing.md)
            .background(StillwaterColors.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
        }
        .disabled(isLocked)
    }
}

#Preview {
    ExploreGrid(
        isToolkitUnlocked: false,
        onCalmCardsTap: {},
        onToolkitTap: {},
        onAdventuresTap: {}
    )
    .padding()
}
