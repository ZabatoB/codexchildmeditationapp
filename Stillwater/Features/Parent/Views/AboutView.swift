import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: StillwaterSpacing.xl) {
                MiloCharacter(mood: .happy, size: .large)
                    .padding(.top, StillwaterSpacing.xl)

                VStack(spacing: StillwaterSpacing.xs) {
                    Text("Stillwater")
                        .font(StillwaterFont.displayMedium)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text("Meditation for growing minds")
                        .font(StillwaterFont.bodyMedium)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }

                VStack(spacing: StillwaterSpacing.md) {
                    Text("Stillwater helps children ages 4-12 learn mindfulness through playful, engaging exercises.")
                        .font(StillwaterFont.bodyMedium)
                        .foregroundStyle(StillwaterColors.textSecondary)
                        .multilineTextAlignment(.center)

                    Text("Our approach focuses on building real skills—not just empty gamification—that children can use throughout their lives.")
                        .font(StillwaterFont.bodyMedium)
                        .foregroundStyle(StillwaterColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, StillwaterSpacing.lg)

                VStack(spacing: StillwaterSpacing.xxs) {
                    Text("Version 1.0.0")
                        .font(StillwaterFont.labelSmall)
                        .foregroundStyle(StillwaterColors.textTertiary)

                    Text("Made with 💚")
                        .font(StillwaterFont.labelSmall)
                        .foregroundStyle(StillwaterColors.textTertiary)
                }
                .padding(.top, StillwaterSpacing.xl)

                Spacer(minLength: StillwaterSpacing.xxl)
            }
        }
        .background(StillwaterColors.bgPrimary.ignoresSafeArea())
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
