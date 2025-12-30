import SwiftUI

struct ParentWelcomeView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showContent = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: StillwaterSpacing.xl) {
            Spacer()

            MiloCharacter(mood: .breathing, size: .large)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)

            VStack(spacing: StillwaterSpacing.sm) {
                Text("Welcome to Stillwater")
                    .font(StillwaterFont.displayMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("Meditation designed for growing minds")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
                TrustPoint(icon: "checkmark.circle.fill", text: "No ads, ever")
                TrustPoint(icon: "checkmark.circle.fill", text: "No guilt or pressure")
                TrustPoint(icon: "checkmark.circle.fill", text: "Real skills, not empty rewards")
            }
            .padding(.horizontal, StillwaterSpacing.xl)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            Spacer()

            VStack(spacing: StillwaterSpacing.md) {
                PrimaryButton("Get Started") {
                    viewModel.goToNextStep()
                }

                GentleButton("Already have an account?") {
                    // TODO: Future sign-in flow
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .padding(.bottom, StillwaterSpacing.xxl)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 20)
        }
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
            withAnimation(StillwaterAnimation.slowEase.delay(0.6)) {
                showButton = true
            }
        }
    }
}

struct TrustPoint: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: StillwaterSpacing.sm) {
            Image(systemName: icon)
                .foregroundStyle(StillwaterColors.sage)
                .font(.system(size: 20))

            Text(text)
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textPrimary)
        }
    }
}

#Preview {
    ParentWelcomeView()
        .environment(OnboardingViewModel())
}
