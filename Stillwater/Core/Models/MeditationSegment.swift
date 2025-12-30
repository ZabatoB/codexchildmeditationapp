import Foundation

struct MeditationSegment: Identifiable, Codable, Equatable {
    let id: UUID
    let type: SegmentType
    let durationSeconds: Double
    let transcript: String?
    let visualCue: VisualCue

    // For breath cycles
    let inhaleSeconds: Double?
    let exhaleSeconds: Double?
    let holdSeconds: Double?
    let cycles: Int?
    let inhaleText: String?
    let exhaleText: String?

    // For interactive
    let options: [String]?

    // For conditional
    let conditions: [String: String]?

    // For skill earned
    let skillEarned: UUID?

    enum SegmentType: String, Codable {
        case audio
        case silence
        case timedBreath
        case breathCycle
        case timedAction
        case feelingCheck
        case conditionalAudio
        case completion
        case fadeToSilence
        case interactive
    }

    enum VisualCue: String, Codable {
        case none
        case miloDemo
        case breatheIn
        case breatheOut
        case breathingCircle
        case resting
        case feelingSelector
        case cardEarned
        case squeezeFists
        case holdTension
        case release
        case squeezeRelease
    }

    init(
        id: UUID = UUID(),
        type: SegmentType,
        durationSeconds: Double = 0,
        transcript: String? = nil,
        visualCue: VisualCue = .none,
        inhaleSeconds: Double? = nil,
        exhaleSeconds: Double? = nil,
        holdSeconds: Double? = nil,
        cycles: Int? = nil,
        inhaleText: String? = nil,
        exhaleText: String? = nil,
        options: [String]? = nil,
        conditions: [String: String]? = nil,
        skillEarned: UUID? = nil
    ) {
        self.id = id
        self.type = type
        self.durationSeconds = durationSeconds
        self.transcript = transcript
        self.visualCue = visualCue
        self.inhaleSeconds = inhaleSeconds
        self.exhaleSeconds = exhaleSeconds
        self.holdSeconds = holdSeconds
        self.cycles = cycles
        self.inhaleText = inhaleText
        self.exhaleText = exhaleText
        self.options = options
        self.conditions = conditions
        self.skillEarned = skillEarned
    }
}
