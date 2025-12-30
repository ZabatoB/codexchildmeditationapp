import SwiftUI

struct ProgressRing: View {
    let progress: Double  // 0.0 to 1.0
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color

    init(
        progress: Double,
        size: CGFloat = 60,
        lineWidth: CGFloat = 6,
        color: Color = StillwaterColors.sage
    ) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(StillwaterAnimation.slowEase, value: progress)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 20) {
        ProgressRing(progress: 0.25)
        ProgressRing(progress: 0.5, color: StillwaterColors.sky)
        ProgressRing(progress: 0.75, color: StillwaterColors.sunrise)
        ProgressRing(progress: 1.0, color: StillwaterColors.lavender)
    }
    .padding()
}
