import Foundation

struct GardenState: Codable, Equatable {
    var plantGrowth: Double
    var plantsUnlocked: Int
    var lastWatered: Date?

    init(
        plantGrowth: Double = 0.0,
        plantsUnlocked: Int = 0,
        lastWatered: Date? = nil
    ) {
        self.plantGrowth = plantGrowth
        self.plantsUnlocked = plantsUnlocked
        self.lastWatered = lastWatered
    }

    mutating func water() {
        lastWatered = Date()
        plantGrowth = min(1.0, plantGrowth + 0.05)

        // Unlock new plant at certain thresholds
        let newPlantsUnlocked = Int(plantGrowth * 10)
        if newPlantsUnlocked > plantsUnlocked {
            plantsUnlocked = newPlantsUnlocked
        }
    }
}
