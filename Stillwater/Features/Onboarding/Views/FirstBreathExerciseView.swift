import SwiftUI

struct FirstBreathExerciseView: View {
    @Environment(OnboardingViewModel.self) private var viewModel
    @State private var exerciseVM = FirstBreathExerciseViewModel()

    var body: some View {
        ZStack {
            AnimatedBreathingBackground(phase: exerciseVM.breathPhase)

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                BreathingCircle(
                    phase: exerciseVM.breathPhase,
                    size: 200,
                    color: StillwaterColors.sky
                )

                MiloCharacter(
                    mood: exerciseVM.miloMood,
                    size: .medium
                )
                .padding(.top, StillwaterSpacing.lg)

                Text(exerciseVM.currentText)
                    .font(StillwaterFont.miloSpeaking)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StillwaterSpacing.xl)
                    .frame(minHeight: 80)
                    .animation(.easeInOut(duration: 0.3), value: exerciseVM.currentText)

                Spacer()

                ExerciseProgressDots(
                    current: exerciseVM.currentPhaseIndex,
                    total: exerciseVM.totalPhases
                )
                .padding(.bottom, StillwaterSpacing.xxl)
            }
        }
        .onAppear {
            exerciseVM.startExercise {
                viewModel.goToNextStep()
            }
        }
        .onDisappear {
            exerciseVM.stopExercise()
        }
    }
}

struct AnimatedBreathingBackground: View {
    let phase: BreathingCircle.Phase

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 2), value: phase)
    }

    private var gradientColors: [Color] {
        switch phase {
        case .inhale:
            return [
                Color(hex: "E8F4F8"),
                Color(hex: "D4E8E0")
            ]
        case .exhale:
            return [
                Color(hex: "F0E8E4"),
                Color(hex: "E8DFD0")
            ]
        default:
            return [
                Color(hex: "FDFBF7"),
                Color(hex: "F0E8E4")
            ]
        }
    }
}

struct ExerciseProgressDots: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: StillwaterSpacing.xs) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index <= current ? StillwaterColors.sage : StillwaterColors.sage.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: current)
            }
        }
    }
}

#Preview {
    FirstBreathExerciseView()
        .environment(OnboardingViewModel())
}
