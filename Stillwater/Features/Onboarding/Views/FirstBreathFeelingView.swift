import SwiftUI

struct FirstBreathFeelingView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showContent = false
    @State private var showResponse = false

    var body: some View {
        ZStack {
            StillwaterGradients.breathing
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                MiloCharacter(
                    mood: viewModel.selectedFeeling != nil ? .happy : .curious,
                    size: .large
                )
                .opacity(showContent ? 1 : 0)

                if viewModel.selectedFeeling == nil {
                    Text("How does your body feel right now?")
                        .font(StillwaterFont.headlineLarge)
                        .foregroundStyle(StillwaterColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, StillwaterSpacing.lg)
                        .opacity(showContent ? 1 : 0)

                    FeelingSelector(
                        selected: Binding(
                            get: { viewModel.selectedFeeling },
                            set: { feeling in
                                if let feeling = feeling {
                                    viewModel.selectFeeling(feeling)
                                    withAnimation(StillwaterAnimation.standardEase.delay(0.3)) {
                                        showResponse = true
                                    }
                                }
                            }
                        ),
                        options: Feeling.postSessionFeelings,
                        style: .horizontal
                    )
                    .padding(.horizontal, StillwaterSpacing.lg)
                    .opacity(showContent ? 1 : 0)

                } else {
                    VStack(spacing: StillwaterSpacing.md) {
                        Text(responseText)
                            .font(StillwaterFont.miloSpeaking)
                            .foregroundStyle(StillwaterColors.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, StillwaterSpacing.lg)
                    }
                    .opacity(showResponse ? 1 : 0)
                    .offset(y: showResponse ? 0 : 20)
                }

                Spacer()

                if viewModel.selectedFeeling != nil {
                    PrimaryButton("Continue") {
                        viewModel.goToNextStep()
                    }
                    .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                    .padding(.bottom, StillwaterSpacing.xxl)
                    .opacity(showResponse ? 1 : 0)
                }
            }
        }
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }

    private var responseText: String {
        switch viewModel.selectedFeeling {
        case .calm:
            return "I feel it too! That's your calm superpower. You can do this anytime you want to feel this way."
        case .same:
            return "That's okay! Sometimes it takes practice to notice the calm feelings. Your body DID get calmer, even if it's hard to feel right now."
        case .unsure:
            return "That's completely fine! The more you practice, the easier it gets to notice how your body feels."
        default:
            return "Great job trying something new!"
        }
    }
}

#Preview {
    FirstBreathFeelingView()
        .environment(OnboardingViewModel())
}
