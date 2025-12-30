import SwiftUI

struct FirstBreathIntroView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showContent = false

    var body: some View {
        VStack(spacing: StillwaterSpacing.xl) {
            Spacer()

            MiloCharacter(mood: .breathing, size: .large)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)

            VStack(spacing: StillwaterSpacing.md) {
                Text("Want to try something right now?")
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("It's called Balloon Breath. It's really easy and it feels nice.")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)

                Text("Just 2 minutes. Ready?")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }
            .padding(.horizontal, StillwaterSpacing.lg)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            Spacer()

            VStack(spacing: StillwaterSpacing.md) {
                PrimaryButton("Let's try it! 🎈") {
                    viewModel.startFirstBreath()
                }

                GentleButton("Maybe later") {
                    viewModel.skipFirstBreath()
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .padding(.bottom, StillwaterSpacing.xxl)
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }
}

#Preview {
    FirstBreathIntroView()
        .environment(OnboardingViewModel())
}
