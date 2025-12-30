import Foundation

struct AppConfig: Codable {
    let appName: String
    let version: String
    let minimumAge: Int
    let maximumAge: Int
    let defaultSessionLengthMinutes: Int
    let maxSessionLengthMinutes: Int
    let streakResetHours: Int
    let gardenGrowthPerSession: Double
    let maxGardenGrowth: Double
    let sessionsToUnlockToolkit: Int
    let skillLearningThreshold: Int
    let defaultAgeRange: String
    let miloMessages: MiloMessages
    let feelingLabels: [String: String]
    let categoryLabels: [String: String]
    let ageRangeLabels: [String: String]
}

struct MiloMessages: Codable {
    let greeting: [String]
    let encouragement: [String]
    let `return`: [String]
    let completion: [String]
    let gardenGrowth: [String]
    let streakCelebration: [String]
    let firstTime: [String]

    func randomGreeting(name: String) -> String {
        let message = greeting.randomElement() ?? "Hi!"
        return message.replacingOccurrences(of: "{name}", with: name)
    }

    func randomCompletion(name: String) -> String {
        let message = completion.randomElement() ?? "Great job!"
        return message.replacingOccurrences(of: "{name}", with: name)
    }

    func randomStreakCelebration(streak: Int) -> String {
        let message = streakCelebration.randomElement() ?? "{streak} days!"
        return message.replacingOccurrences(of: "{streak}", with: "\(streak)")
    }
}
