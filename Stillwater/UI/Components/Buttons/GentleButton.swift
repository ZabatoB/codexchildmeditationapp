import SwiftUI

struct GentleButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: StillwaterSpacing.xxs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                }
                Text(title)
                    .font(StillwaterFont.labelMedium)
            }
            .foregroundStyle(StillwaterColors.textSecondary)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        GentleButton("Maybe later") {}
        GentleButton("Skip", icon: "chevron.right") {}
    }
    .padding()
}
