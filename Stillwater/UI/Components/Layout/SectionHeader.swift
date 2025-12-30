import SwiftUI

struct SectionHeader: View {
    let title: String
    let icon: String?
    let action: (() -> Void)?
    let actionLabel: String?

    init(
        _ title: String,
        icon: String? = nil,
        action: (() -> Void)? = nil,
        actionLabel: String? = nil
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.actionLabel = actionLabel
    }

    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(StillwaterColors.sage)
            }

            Text(title)
                .font(StillwaterFont.headlineSmall)
                .foregroundStyle(StillwaterColors.textPrimary)

            Spacer()

            if let action = action, let actionLabel = actionLabel {
                Button(action: action) {
                    Text(actionLabel)
                        .font(StillwaterFont.labelMedium)
                        .foregroundStyle(StillwaterColors.sage)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SectionHeader("Calm Cards", icon: "square.stack.fill")
        SectionHeader("Recent", action: {}, actionLabel: "See all")
    }
    .padding()
}
