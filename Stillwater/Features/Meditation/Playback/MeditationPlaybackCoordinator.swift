import Observation
import SwiftUI

@Observable
final class MeditationPlaybackCoordinator {

    private(set) var currentSegmentIndex: Int = 0
    private(set) var isPlaying: Bool = false
    private(set) var isPaused: Bool = false
    private(set) var breathPhase: BreathingCircle.Phase = .idle
    private(set) var currentText: String = ""
    private(set) var miloMood: MiloCharacter.Mood = .neutral
    private(set) var visualCue: MeditationSegment.VisualCue = .none
    private(set) var waitingForInteraction: Bool = false
    private(set) var isComplete: Bool = false

    private(set) var showFeelingCheck: Bool = false
    private(set) var feelingOptions: [Feeling] = []

    private(set) var selectedFeeling: Feeling?
    private(set) var earnedSkillId: UUID?

    private var meditation: Meditation?
    private let audioEngine = TTSAudioEngine()
    private var breathCycleTask: Task<Void, Never>?

    var totalSegments: Int {
        meditation?.segments.count ?? 0
    }

    var progress: Double {
        guard totalSegments > 0 else { return 0 }
        return Double(currentSegmentIndex) / Double(totalSegments)
    }

    func start(meditation: Meditation) {
        self.meditation = meditation
        currentSegmentIndex = 0
        isPlaying = true
        isPaused = false
        isComplete = false
        selectedFeeling = nil
        earnedSkillId = nil

        playCurrentSegment()
    }

    func pause() {
        guard isPlaying && !isPaused else { return }
        isPaused = true
        audioEngine.pause()
        breathCycleTask?.cancel()
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        audioEngine.resume()
    }

    func stop() {
        isPlaying = false
        isPaused = false
        audioEngine.stop()
        breathCycleTask?.cancel()
        breathPhase = .idle
    }

    func selectFeeling(_ feeling: Feeling) {
        selectedFeeling = feeling
        showFeelingCheck = false
        waitingForInteraction = false
        advanceToNextSegment()
    }

    private func playCurrentSegment() {
        guard let meditation = meditation,
              currentSegmentIndex < meditation.segments.count else {
            handleMeditationComplete()
            return
        }

        let segment = meditation.segments[currentSegmentIndex]
        visualCue = segment.visualCue

        switch segment.type {
        case .audio:
            handleAudioSegment(segment)
        case .silence:
            handleSilenceSegment(segment)
        case .timedBreath:
            handleTimedBreathSegment(segment)
        case .breathCycle:
            handleBreathCycleSegment(segment)
        case .timedAction:
            handleTimedActionSegment(segment)
        case .feelingCheck:
            handleFeelingCheckSegment(segment)
        case .conditionalAudio:
            handleConditionalAudioSegment(segment)
        case .completion:
            handleCompletionSegment(segment)
        case .fadeToSilence:
            handleFadeToSilenceSegment(segment)
        case .interactive:
            handleInteractiveSegment(segment)
        }
    }

    private func advanceToNextSegment() {
        currentSegmentIndex += 1
        playCurrentSegment()
    }

    private func handleMeditationComplete() {
        isComplete = true
        isPlaying = false
        breathPhase = .idle
    }

    private func handleAudioSegment(_ segment: MeditationSegment) {
        currentText = segment.transcript ?? ""
        miloMood = .neutral
        breathPhase = .idle

        audioEngine.speak(segment.transcript ?? "") { [weak self] in
            self?.advanceToNextSegment()
        }
    }

    private func handleSilenceSegment(_ segment: MeditationSegment) {
        currentText = ""
        miloMood = .peaceful

        audioEngine.startSilence(duration: segment.durationSeconds) { [weak self] in
            self?.advanceToNextSegment()
        }
    }

    private func handleTimedBreathSegment(_ segment: MeditationSegment) {
        let inhale = segment.inhaleSeconds ?? 4
        let exhale = segment.exhaleSeconds ?? 4

        currentText = segment.inhaleText ?? "Breathe in..."
        miloMood = .breathing
        breathPhase = .inhale(duration: inhale)

        breathCycleTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(inhale))
            guard !Task.isCancelled else { return }

            currentText = segment.exhaleText ?? "Breathe out..."
            breathPhase = .exhale(duration: exhale)

            try? await Task.sleep(for: .seconds(exhale))
            guard !Task.isCancelled else { return }

            breathPhase = .idle
            advanceToNextSegment()
        }
    }

    private func handleBreathCycleSegment(_ segment: MeditationSegment) {
        let inhale = segment.inhaleSeconds ?? 4
        let hold = segment.holdSeconds ?? 0
        let exhale = segment.exhaleSeconds ?? 4
        let cycles = segment.cycles ?? 3
        let inhaleText = segment.inhaleText ?? "Breathe in..."
        let exhaleText = segment.exhaleText ?? "Breathe out..."

        miloMood = .breathing

        breathCycleTask = Task { @MainActor in
            for cycle in 0..<cycles {
                guard !Task.isCancelled else { return }

                currentText = inhaleText
                breathPhase = .inhale(duration: inhale)
                try? await Task.sleep(for: .seconds(inhale))
                guard !Task.isCancelled else { return }

                if hold > 0 {
                    currentText = "Hold..."
                    breathPhase = .hold(duration: hold)
                    try? await Task.sleep(for: .seconds(hold))
                    guard !Task.isCancelled else { return }
                }

                currentText = exhaleText
                breathPhase = .exhale(duration: exhale)
                try? await Task.sleep(for: .seconds(exhale))
                guard !Task.isCancelled else { return }

                if cycle < cycles - 1 {
                    breathPhase = .idle
                    try? await Task.sleep(for: .seconds(0.5))
                }
            }

            breathPhase = .idle
            currentText = ""
            advanceToNextSegment()
        }
    }

    private func handleTimedActionSegment(_ segment: MeditationSegment) {
        currentText = segment.transcript ?? ""
        miloMood = .encouraging
        breathPhase = .idle

        audioEngine.startSilence(duration: segment.durationSeconds) { [weak self] in
            self?.advanceToNextSegment()
        }
    }

    private func handleFeelingCheckSegment(_ segment: MeditationSegment) {
        waitingForInteraction = true
        showFeelingCheck = true
        currentText = ""
        miloMood = .curious
        breathPhase = .idle

        if let options = segment.options {
            feelingOptions = options.compactMap { Feeling(rawValue: $0) }
        } else {
            feelingOptions = Feeling.postSessionFeelings
        }
    }

    private func handleConditionalAudioSegment(_ segment: MeditationSegment) {
        guard let conditions = segment.conditions,
              let feeling = selectedFeeling,
              let text = conditions[feeling.rawValue] else {
            advanceToNextSegment()
            return
        }

        currentText = text
        miloMood = .happy
        breathPhase = .idle

        audioEngine.speak(text) { [weak self] in
            self?.advanceToNextSegment()
        }
    }

    private func handleCompletionSegment(_ segment: MeditationSegment) {
        earnedSkillId = segment.skillEarned
        handleMeditationComplete()
    }

    private func handleFadeToSilenceSegment(_ segment: MeditationSegment) {
        currentText = ""
        miloMood = .sleepy
        breathPhase = .idle

        audioEngine.startSilence(duration: segment.durationSeconds) { [weak self] in
            self?.advanceToNextSegment()
        }
    }

    private func handleInteractiveSegment(_ segment: MeditationSegment) {
        advanceToNextSegment()
    }
}
