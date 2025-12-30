import SwiftUI

@Observable
final class FirstBreathExerciseViewModel {

    // MARK: - State
    var currentText: String = ""
    var breathPhase: BreathingCircle.Phase = .idle
    var miloMood: MiloCharacter.Mood = .neutral
    var currentPhaseIndex: Int = 0
    let totalPhases: Int = 7

    private var timer: Timer?
    private var onComplete: (() -> Void)?

    // MARK: - Exercise Sequence
    private struct ExerciseStep {
        let text: String
        let duration: TimeInterval
        let breathPhase: BreathingCircle.Phase
        let miloMood: MiloCharacter.Mood
    }

    private let steps: [ExerciseStep] = [
        ExerciseStep(
            text: "Get comfortable and close your eyes.",
            duration: 4,
            breathPhase: .idle,
            miloMood: .peaceful
        ),
        ExerciseStep(
            text: "Put your hands on your belly, like this.",
            duration: 4,
            breathPhase: .idle,
            miloMood: .neutral
        ),
        ExerciseStep(
            text: "We're going to blow up a balloon inside your belly!",
            duration: 4,
            breathPhase: .idle,
            miloMood: .encouraging
        ),
        ExerciseStep(
            text: "Breathe in... 2... 3... 4...",
            duration: 4,
            breathPhase: .inhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "And out... 2... 3... 4...",
            duration: 4,
            breathPhase: .exhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "You did it! Let's do it again...",
            duration: 2,
            breathPhase: .idle,
            miloMood: .happy
        ),
        ExerciseStep(
            text: "Breathe in...",
            duration: 4,
            breathPhase: .inhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "And out...",
            duration: 4,
            breathPhase: .exhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "Breathe in...",
            duration: 4,
            breathPhase: .inhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "And out...",
            duration: 4,
            breathPhase: .exhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "Breathe in...",
            duration: 4,
            breathPhase: .inhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "And out...",
            duration: 4,
            breathPhase: .exhale(duration: 4),
            miloMood: .breathing
        ),
        ExerciseStep(
            text: "Now just breathe normal. Notice how you feel.",
            duration: 5,
            breathPhase: .idle,
            miloMood: .peaceful
        )
    ]

    private var currentStepIndex = 0

    // MARK: - Control
    func startExercise(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        currentStepIndex = 0
        executeStep()
    }

    func stopExercise() {
        timer?.invalidate()
        timer = nil
    }

    private func executeStep() {
        guard currentStepIndex < steps.count else {
            onComplete?()
            return
        }

        let step = steps[currentStepIndex]

        withAnimation(.easeInOut(duration: 0.3)) {
            currentText = step.text
            breathPhase = step.breathPhase
            miloMood = step.miloMood

            currentPhaseIndex = min(currentStepIndex / 2, totalPhases - 1)
        }

        timer = Timer.scheduledTimer(withTimeInterval: step.duration, repeats: false) { [weak self] _ in
            self?.currentStepIndex += 1
            self?.executeStep()
        }
    }
}
