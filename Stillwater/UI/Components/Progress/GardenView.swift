import SwiftUI

struct GardenView: View {
    let gardenState: GardenState
    let size: Size

    enum Size {
        case compact  // For home screen
        case full     // For detail view

        var height: CGFloat {
            switch self {
            case .compact: return 120
            case .full: return 200
            }
        }
    }

    var body: some View {
        ZStack {
            // Ground
            RoundedRectangle(cornerRadius: StillwaterRadius.large)
                .fill(
                    LinearGradient(
                        colors: [
                            StillwaterColors.sand,
                            StillwaterColors.sage.opacity(0.3)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Plants
            HStack(spacing: StillwaterSpacing.lg) {
                ForEach(0..<5) { index in
                    PlantView(
                        isGrown: index < gardenState.plantsUnlocked,
                        growthProgress: index == gardenState.plantsUnlocked
                            ? gardenState.plantGrowth.truncatingRemainder(dividingBy: 0.2) / 0.2
                            : (index < gardenState.plantsUnlocked ? 1.0 : 0.0)
                    )
                }
            }
            .padding(.horizontal, StillwaterSpacing.lg)
        }
        .frame(height: size.height)
    }
}

struct PlantView: View {
    let isGrown: Bool
    let growthProgress: Double

    var body: some View {
        VStack {
            Spacer()

            if isGrown || growthProgress > 0 {
                // Stem
                RoundedRectangle(cornerRadius: 2)
                    .fill(StillwaterColors.sage)
                    .frame(width: 4, height: 30 * (isGrown ? 1.0 : growthProgress))

                // Flower/leaves (if fully grown)
                if isGrown {
                    Circle()
                        .fill(plantColor)
                        .frame(width: 20, height: 20)
                        .offset(y: 10)
                }
            } else {
                // Seed dot
                Circle()
                    .fill(StillwaterColors.sand.opacity(0.5))
                    .frame(width: 8, height: 8)
            }
        }
        .frame(height: 60)
    }

    private var plantColor: Color {
        [
            StillwaterColors.sunrise,
            StillwaterColors.lavender,
            StillwaterColors.sky,
            StillwaterColors.sage,
            Color.pink.opacity(0.7)
        ].randomElement() ?? StillwaterColors.sage
    }
}

#Preview {
    VStack(spacing: 20) {
        GardenView(
            gardenState: GardenState(plantGrowth: 0.35, plantsUnlocked: 3),
            size: .compact
        )

        GardenView(
            gardenState: GardenState(plantGrowth: 0.0, plantsUnlocked: 0),
            size: .compact
        )
    }
    .padding()
}
