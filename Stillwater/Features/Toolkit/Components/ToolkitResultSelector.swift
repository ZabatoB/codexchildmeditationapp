import SwiftUI

struct ToolkitResultSelector: View {
    let originalFeeling: Feeling
    let options: [Feeling]
    let onSelect: (Feeling) -> Void

    var body: some View {
        VStack(spacing: StillwaterSpacing.lg) {
            Text("How do you feel now?")
                .font(StillwaterFont.headlineMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            HStack(spacing: StillwaterSpacing.md) {
                ForEach(options, id: \.self) { feeling in
                    ToolkitResultButton(feeling: feeling) {
                        onSelect(feeling)
                    }
                }
            }
        }
        .padding(StillwaterSpacing.xl)
        .background(StillwaterColors.bgPrimary)
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.xlarge))
        .stillwaterShadow(.lifted)
    }
}

struct ToolkitResultButton: View {
    let feeling: Feeling
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: StillwaterSpacing.xs) {
                Text(feeling.emoji)
                    .font(.system(size: 36))

                Text(feeling.shortDisplayName)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 90, height: 90)
            .background(feeling.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
        }
    }
}

extension Feeling {
    var shortDisplayName: String {
        switch self {
        case .better: return "Better"
        case .littleBetter: return "A little better"
        case .stillAngry: return "Still angry"
        case .stillWorried: return "Still worried"
        case .stillSad: return "Still sad"
        case .stillOverwhelmed: return "Still overwhelmed"
        case .stillCantSleep: return "Still can't sleep"
        default: return displayName
        }
    }
}

#Preview {
    ToolkitResultSelector(
        originalFeeling: .angry,
        options: [.better, .littleBetter, .stillAngry],
        onSelect: { _ in }
    )
    .padding()
    .background(Color.gray.opacity(0.3))
}
