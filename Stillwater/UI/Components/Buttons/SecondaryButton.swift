import SwiftUI

struct SecondaryButton: View {
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
            HStack(spacing: StillwaterSpacing.xs) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                Text(title)
                    .font(StillwaterFont.buttonTextSmall)
            }
            .foregroundStyle(StillwaterColors.sage)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: StillwaterRadius.medium)
                    .strokeBorder(StillwaterColors.sage, lineWidth: 2)
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        SecondaryButton("Choose something else") {}
        SecondaryButton("Back", icon: "chevron.left") {}
    }
    .padding()
}
