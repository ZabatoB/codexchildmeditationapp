import SwiftUI

struct MeetMiloView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showMilo = false
    @State private var showText = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: StillwaterSpacing.xl) {
            Spacer()

            MiloCharacter(mood: .waving, size: .hero)
                .opacity(showMilo ? 1 : 0)
                .scaleEffect(showMilo ? 1 : 0.5)

            VStack(spacing: StillwaterSpacing.md) {
                Text("Hi! I'm Milo.")
                    .font(StillwaterFont.displaySmall)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("I'm so happy to meet you, \(viewModel.childName)!")
                    .font(StillwaterFont.miloSpeaking)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("I'll teach you some cool tricks for feeling calm, falling asleep, and handling big feelings.")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)

                Text("They're like superpowers for your mind! 🧠✨")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }
            .padding(.horizontal, StillwaterSpacing.lg)
            .opacity(showText ? 1 : 0)
            .offset(y: showText ? 0 : 20)

            Spacer()

            PrimaryButton("That sounds cool!") {
                viewModel.goToNextStep()
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .padding(.bottom, StillwaterSpacing.xxl)
            .opacity(showButton ? 1 : 0)
            .offset(y: showButton ? 0 : 20)
        }
        .onAppear {
            withAnimation(StillwaterAnimation.gentleEase.delay(0.1)) {
                showMilo = true
            }
            withAnimation(StillwaterAnimation.gentleEase.delay(0.5)) {
                showText = true
            }
            withAnimation(StillwaterAnimation.gentleEase.delay(1.0)) {
                showButton = true
            }
        }
    }
}

#Preview {
    MeetMiloView()
        .environment({
            let vm = OnboardingViewModel()
            vm.childName = "Emma"
            return vm
        }())
}
