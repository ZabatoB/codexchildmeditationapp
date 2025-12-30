import SwiftUI

@Observable
final class OnboardingViewModel {

    // MARK: - Step Management
    enum Step: Int, CaseIterable {
        case parentWelcome = 0
        case childProfile = 1
        case parentPIN = 2
        case handoff = 3
        case meetMilo = 4
        case firstBreathIntro = 5
        case firstBreathExercise = 6
        case firstBreathFeeling = 7
        case firstSkillEarned = 8
        case welcomeComplete = 9

        var isChildPhase: Bool {
            self.rawValue >= Step.meetMilo.rawValue
        }

        var isParentPhase: Bool {
            !isChildPhase
        }

        var canGoBack: Bool {
            switch self {
            case .parentWelcome, .handoff, .meetMilo, .firstBreathExercise,
                 .firstBreathFeeling, .firstSkillEarned, .welcomeComplete:
                return false
            default:
                return true
            }
        }
    }

    var currentStep: Step = .parentWelcome

    // MARK: - Child Profile Data
    var childName: String = ""
    var selectedAgeRange: ChildProfile.AgeRange = .middle
    var meditationExperience: MeditationExperience = .never

    enum MeditationExperience: String, CaseIterable, Identifiable {
        case never = "Never"
        case aLittle = "A little"
        case regularly = "Regularly"

        var id: String { rawValue }
    }

    // MARK: - PIN Data
    var enteredPIN: String = ""
    var confirmPIN: String = ""
    var pinStep: PINStep = .enter
    var pinError: String?

    enum PINStep {
        case enter
        case confirm
    }

    // MARK: - First Breath Data
    var skippedFirstBreath: Bool = false
    var selectedFeeling: Feeling?
    var exerciseStartTime: Date?

    // MARK: - Validation
    var isChildProfileValid: Bool {
        !childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var isPINComplete: Bool {
        enteredPIN.count == 4
    }

    var isPINConfirmed: Bool {
        confirmPIN.count == 4 && enteredPIN == confirmPIN
    }

    var isPINMismatch: Bool {
        confirmPIN.count == 4 && enteredPIN != confirmPIN
    }

    // MARK: - Navigation Actions
    func goToNextStep() {
        guard let nextIndex = Step(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = nextIndex
    }

    func goToPreviousStep() {
        guard currentStep.canGoBack,
              let prevIndex = Step(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = prevIndex
    }

    func goToStep(_ step: Step) {
        currentStep = step
    }

    // MARK: - PIN Actions
    func appendPINDigit(_ digit: String) {
        switch pinStep {
        case .enter:
            if enteredPIN.count < 4 {
                enteredPIN += digit
            }
            if enteredPIN.count == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.pinStep = .confirm
                }
            }
        case .confirm:
            if confirmPIN.count < 4 {
                confirmPIN += digit
                pinError = nil
            }
        }
    }

    func deletePINDigit() {
        switch pinStep {
        case .enter:
            if !enteredPIN.isEmpty {
                enteredPIN.removeLast()
            }
        case .confirm:
            if !confirmPIN.isEmpty {
                confirmPIN.removeLast()
                pinError = nil
            }
        }
    }

    func resetPINConfirmation() {
        confirmPIN = ""
        pinError = "PINs don't match. Try again."
    }

    func resetPINEntry() {
        enteredPIN = ""
        confirmPIN = ""
        pinStep = .enter
        pinError = nil
    }

    // MARK: - First Breath Actions
    func startFirstBreath() {
        exerciseStartTime = Date()
        goToStep(.firstBreathExercise)
    }

    func skipFirstBreath() {
        skippedFirstBreath = true
        goToStep(.welcomeComplete)
    }

    func selectFeeling(_ feeling: Feeling) {
        selectedFeeling = feeling
    }

    // MARK: - Completion
    func createChildProfile() -> ChildProfile {
        let trimmedName = childName.trimmingCharacters(in: .whitespacesAndNewlines)

        var profile = ChildProfile(
            name: trimmedName,
            ageRange: selectedAgeRange
        )

        if !skippedFirstBreath {
            profile.gardenState = GardenState(
                plantGrowth: 0.05,
                plantsUnlocked: 1,
                lastWatered: Date()
            )
        }

        return profile
    }
}
