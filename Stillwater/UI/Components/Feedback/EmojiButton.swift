import SwiftUI

struct EmojiButton: View {
    let emoji: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    init(
        emoji: String,
        label: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.emoji = emoji
        self.label = label
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: StillwaterSpacing.xs) {
                Text(emoji)
                    .font(.system(size: 32))
                Text(label)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }
            .padding(StillwaterSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: StillwaterRadius.medium)
                    .fill(isSelected ? StillwaterColors.sage.opacity(0.15) : StillwaterColors.bgTertiary)
            )
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        EmojiButton(emoji: "😌", label: "Calm", isSelected: true) {}
        EmojiButton(emoji: "😐", label: "Same") {}
    }
    .padding()
}
