import SwiftUI

struct FeelingOptionCard: View {
    let feeling: Feeling
    var style: Style = .square
    let action: () -> Void

    enum Style {
        case square
        case wide
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: StillwaterSpacing.sm) {
                Text(feeling.emoji)
                    .font(.system(size: style == .wide ? 36 : 44))

                Text(feeling.displayName)
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: style == .wide ? 100 : 120)
            .background(feeling.color.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: StillwaterRadius.large)
                    .strokeBorder(feeling.color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
            withAnimation(StillwaterAnimation.quickEase) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 16) {
            FeelingOptionCard(feeling: .angry) {}
            FeelingOptionCard(feeling: .worried) {}
        }
        FeelingOptionCard(feeling: .cantSleep, style: .wide) {}
    }
    .padding()
}
