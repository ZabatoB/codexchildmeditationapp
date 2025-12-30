import SwiftUI

struct WelcomeCompleteView: View {
    @Environment(OnboardingViewModel.self) private var viewModel
    @Environment(AppState.self) private var appState

    @State private var showContent = false

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                MiloCharacter(mood: .waving, size: .large)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)

                VStack(spacing: StillwaterSpacing.sm) {
                    Text("Welcome to your calm space,")
                        .font(StillwaterFont.headlineLarge)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text("\(viewModel.childName)!")
                        .font(StillwaterFont.displaySmall)
                        .foregroundStyle(StillwaterColors.sage)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                MiniGardenPreview(hasFirstPlant: !viewModel.skippedFirstBreath)
                    .frame(height: 100)
                    .padding(.horizontal, StillwaterSpacing.xl)
                    .opacity(showContent ? 1 : 0)

                Text(viewModel.skippedFirstBreath
                    ? "Your garden is waiting for its first practice!"
                    : "Every time you practice, your garden grows.")
                    .font(StillwaterFont.bodyLarge)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StillwaterSpacing.lg)
                    .opacity(showContent ? 1 : 0)

                Text("Come back tomorrow and we'll learn something new together!")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StillwaterSpacing.lg)
                    .opacity(showContent ? 1 : 0)

                Spacer()

                PrimaryButton("Enter My Space") {
                    completeOnboarding()
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .padding(.bottom, StillwaterSpacing.xxl)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }

    private func completeOnboarding() {
        var child = viewModel.createChildProfile()

        if !viewModel.skippedFirstBreath {
            if let meditation = appState.contentService.allMeditations.first(where: { $0.title == "Balloon Breath" }),
               let skillId = meditation.skillIds.first {

                child.learnedSkillIds.append(skillId)

                let session = Session(
                    childId: child.id,
                    meditationId: meditation.id,
                    startedAt: viewModel.exerciseStartTime ?? Date(),
                    completedAt: Date(),
                    postFeeling: viewModel.selectedFeeling,
                    completedFully: true
                )

                child.completedSessionIds.append(session.id)
                appState.storageService.saveSession(session)
            }
        }

        appState.completeOnboarding(with: child, pin: viewModel.enteredPIN)
    }
}

struct MiniGardenPreview: View {
    let hasFirstPlant: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: StillwaterRadius.large)
                .fill(
                    LinearGradient(
                        colors: [
                            StillwaterColors.sand,
                            StillwaterColors.sage.opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            if hasFirstPlant {
                VStack {
                    Spacer()

                    VStack(spacing: 0) {
                        Circle()
                            .fill(StillwaterColors.sage)
                            .frame(width: 16, height: 16)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(StillwaterColors.sage)
                            .frame(width: 4, height: 20)
                    }
                    .padding(.bottom, StillwaterSpacing.lg)
                }
            } else {
                VStack {
                    Spacer()
                    Circle()
                        .fill(StillwaterColors.sand.opacity(0.8))
                        .frame(width: 12, height: 12)
                        .padding(.bottom, StillwaterSpacing.lg)
                }
            }
        }
    }
}

#Preview {
    WelcomeCompleteView()
        .environment({
            let vm = OnboardingViewModel()
            vm.childName = "Emma"
            vm.skippedFirstBreath = false
            return vm
        }())
        .environment(AppState())
}
