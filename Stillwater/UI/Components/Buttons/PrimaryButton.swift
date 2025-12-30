import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: StillwaterSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text(title)
                        .font(StillwaterFont.buttonText)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(StillwaterColors.sage)
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
            .stillwaterShadow(.soft)
        }
        .disabled(isLoading)
        .animation(StillwaterAnimation.quickEase, value: isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton("Start Practice", icon: "play.fill") {}
        PrimaryButton("Loading...", isLoading: true) {}
    }
    .padding()
}
