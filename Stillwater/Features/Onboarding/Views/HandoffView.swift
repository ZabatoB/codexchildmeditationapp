import SwiftUI

struct HandoffView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showContent = false

    var body: some View {
        VStack(spacing: StillwaterSpacing.xl) {
            Spacer()

            MiloCharacter(mood: .waving, size: .hero)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.8)

            VStack(spacing: StillwaterSpacing.md) {
                Text("Ready to begin!")
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("Hand the device to \(viewModel.childName) when ready.")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            ContentCard {
                VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
                    HStack(spacing: StillwaterSpacing.xs) {
                        Image(systemName: "clock")
                            .foregroundStyle(StillwaterColors.sage)
                        Text("The first session takes about 3 minutes.")
                            .font(StillwaterFont.bodyMedium)
                            .foregroundStyle(StillwaterColors.textPrimary)
                    }

                    HStack(alignment: .top, spacing: StillwaterSpacing.xs) {
                        Image(systemName: "lightbulb.fill")
                            .foregroundStyle(StillwaterColors.sunrise)
                        Text("Tip: Do it together if you can—it helps kids feel safe trying something new.")
                            .font(StillwaterFont.bodyMedium)
                            .foregroundStyle(StillwaterColors.textSecondary)
                    }
                }
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            Spacer()

            PrimaryButton("Begin Child Onboarding") {
                viewModel.goToNextStep()
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
    HandoffView()
        .environment({
            let vm = OnboardingViewModel()
            vm.childName = "Emma"
            return vm
        }())
}
