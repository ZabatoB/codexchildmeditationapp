import SwiftUI

struct PlantView: View {
    let stage: PlantStage
    let isAnimating: Bool
    let plantType: PlantType

    @State private var swayOffset: Double = 0

    var body: some View {
        VStack {
            Spacer()

            plantContent
                .rotationEffect(.degrees(swayOffset))
                .scaleEffect(isAnimating ? 1.2 : 1.0)

            Rectangle()
                .fill(.clear)
                .frame(height: 40)
        }
        .onAppear {
            startIdleAnimation()
        }
    }

    @ViewBuilder
    private var plantContent: some View {
        switch stage {
        case .empty:
            emptySpot
        case .seed:
            seedView
        case .sprout:
            sproutView
        case .growing:
            growingView
        case .budding:
            buddingView
        case .blooming:
            bloomingView
        }
    }

    private var emptySpot: some View {
        Circle()
            .fill(StillwaterColors.sand.opacity(0.5))
            .frame(width: 8, height: 8)
            .offset(y: 16)
    }

    private var seedView: some View {
        Circle()
            .fill(Color(hex: "8B7355"))
            .frame(width: 10, height: 10)
            .offset(y: 14)
    }

    private var sproutView: some View {
        VStack(spacing: 0) {
            Ellipse()
                .fill(StillwaterColors.sage)
                .frame(width: 12, height: 8)
                .rotationEffect(.degrees(-30))
                .offset(x: 4)

            RoundedRectangle(cornerRadius: 2)
                .fill(StillwaterColors.sage)
                .frame(width: 4, height: 20)
        }
    }

    private var growingView: some View {
        VStack(spacing: 0) {
            HStack(spacing: -4) {
                Ellipse()
                    .fill(StillwaterColors.sage)
                    .frame(width: 14, height: 10)
                    .rotationEffect(.degrees(-40))

                Ellipse()
                    .fill(StillwaterColors.sage.opacity(0.8))
                    .frame(width: 14, height: 10)
                    .rotationEffect(.degrees(40))
            }

            RoundedRectangle(cornerRadius: 2)
                .fill(StillwaterColors.sage)
                .frame(width: 4, height: 35)
        }
    }

    private var buddingView: some View {
        VStack(spacing: 0) {
            Circle()
                .fill(budColor.opacity(0.6))
                .frame(width: 16, height: 16)

            HStack(spacing: -4) {
                Ellipse()
                    .fill(StillwaterColors.sage)
                    .frame(width: 12, height: 8)
                    .rotationEffect(.degrees(-50))

                Ellipse()
                    .fill(StillwaterColors.sage)
                    .frame(width: 12, height: 8)
                    .rotationEffect(.degrees(50))
            }
            .offset(y: -4)

            RoundedRectangle(cornerRadius: 2)
                .fill(StillwaterColors.sage)
                .frame(width: 4, height: 40)
        }
    }

    private var bloomingView: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(0..<6, id: \.self) { index in
                    Ellipse()
                        .fill(flowerColor)
                        .frame(width: 12, height: 18)
                        .offset(y: -8)
                        .rotationEffect(.degrees(Double(index) * 60))
                }

                Circle()
                    .fill(centerColor)
                    .frame(width: 10, height: 10)
            }
            .frame(width: 36, height: 36)

            HStack(spacing: -6) {
                Ellipse()
                    .fill(StillwaterColors.sage)
                    .frame(width: 14, height: 10)
                    .rotationEffect(.degrees(-55))

                Ellipse()
                    .fill(StillwaterColors.sage)
                    .frame(width: 14, height: 10)
                    .rotationEffect(.degrees(55))
            }
            .offset(y: -8)

            RoundedRectangle(cornerRadius: 2)
                .fill(StillwaterColors.sage)
                .frame(width: 4, height: 45)
        }
    }

    private var flowerColor: Color {
        switch plantType {
        case .flower1: return StillwaterColors.sunrise
        case .flower2: return StillwaterColors.lavender
        case .flower3: return Color(hex: "FFD93D")
        case .leaf: return StillwaterColors.sage
        case .succulent: return Color(hex: "98D8AA")
        }
    }

    private var centerColor: Color {
        switch plantType {
        case .flower1: return Color(hex: "FFE5B4")
        case .flower2: return Color(hex: "E8DFD0")
        case .flower3: return Color(hex: "8B7355")
        case .leaf: return StillwaterColors.sage.opacity(0.8)
        case .succulent: return Color(hex: "7BA382")
        }
    }

    private var budColor: Color {
        flowerColor
    }

    private func startIdleAnimation() {
        guard stage != .empty && stage != .seed else { return }

        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 2.5...3.5))
                .repeatForever(autoreverses: true)
        ) {
            swayOffset = Double.random(in: -3...3)
        }
    }
}

#Preview {
    HStack(spacing: 30) {
        ForEach(PlantStage.allCases, id: \.rawValue) { stage in
            PlantView(
                stage: stage,
                isAnimating: false,
                plantType: .flower1
            )
            .frame(width: 50, height: 100)
        }
    }
    .padding()
    .background(StillwaterColors.sand)
}
