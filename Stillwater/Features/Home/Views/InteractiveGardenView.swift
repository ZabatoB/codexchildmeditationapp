import SwiftUI

struct InteractiveGardenView: View {
    let gardenState: GardenState
    let totalSessions: Int

    @State private var tappedPlantIndex: Int?

    private let plantCount = 5

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                gardenGround

                HStack(spacing: 0) {
                    ForEach(0..<plantCount, id: \.self) { index in
                        PlantView(
                            stage: plantStage(for: index),
                            isAnimating: tappedPlantIndex == index,
                            plantType: PlantType.allCases[index % PlantType.allCases.count]
                        )
                        .frame(width: geometry.size.width / CGFloat(plantCount))
                        .onTapGesture {
                            withAnimation(StillwaterAnimation.softBounce) {
                                tappedPlantIndex = index
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                tappedPlantIndex = nil
                            }
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.large))
    }

    private var gardenGround: some View {
        VStack(spacing: 0) {
            LinearGradient(
                colors: [
                    Color(hex: "E8F4F8"),
                    Color(hex: "F5F1EA")
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            StillwaterColors.sand,
                            Color(hex: "D4C4B0")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 40)
        }
    }

    private func plantStage(for index: Int) -> PlantStage {
        let sessionsPerPlant = 2
        let requiredSessions = (index + 1) * sessionsPerPlant

        if totalSessions < requiredSessions - 1 {
            return .empty
        } else if totalSessions < requiredSessions {
            return .seed
        } else if totalSessions < requiredSessions + 2 {
            return .sprout
        } else if totalSessions < requiredSessions + 4 {
            return .growing
        } else if totalSessions < requiredSessions + 6 {
            return .budding
        } else {
            return .blooming
        }
    }
}

enum PlantStage: Int, CaseIterable {
    case empty = 0
    case seed = 1
    case sprout = 2
    case growing = 3
    case budding = 4
    case blooming = 5
}

enum PlantType: CaseIterable {
    case flower1
    case flower2
    case flower3
    case leaf
    case succulent
}

#Preview {
    VStack(spacing: 20) {
        InteractiveGardenView(
            gardenState: GardenState(plantGrowth: 0.5, plantsUnlocked: 3),
            totalSessions: 10
        )
        .frame(height: 140)

        InteractiveGardenView(
            gardenState: GardenState(),
            totalSessions: 0
        )
        .frame(height: 140)
    }
    .padding()
}
