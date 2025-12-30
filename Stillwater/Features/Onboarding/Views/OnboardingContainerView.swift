import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            currentStepView
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .animation(StillwaterAnimation.standardEase, value: viewModel.currentStep)
        }
        .environment(viewModel)
    }

    @ViewBuilder
    private var currentStepView: some View {
        switch viewModel.currentStep {
        case .parentWelcome:
            ParentWelcomeView()
        case .childProfile:
            ChildProfileSetupView()
        case .parentPIN:
            ParentPINSetupView()
        case .handoff:
            HandoffView()
        case .meetMilo:
            MeetMiloView()
        case .firstBreathIntro:
            FirstBreathIntroView()
        case .firstBreathExercise:
            FirstBreathExerciseView()
        case .firstBreathFeeling:
            FirstBreathFeelingView()
        case .firstSkillEarned:
            FirstSkillEarnedView()
        case .welcomeComplete:
            WelcomeCompleteView()
        }
    }

    private var backgroundGradient: some View {
        Group {
            if viewModel.currentStep.isChildPhase {
                StillwaterGradients.breathing
            } else {
                StillwaterGradients.daytime
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
        .environment(AppState())
}
