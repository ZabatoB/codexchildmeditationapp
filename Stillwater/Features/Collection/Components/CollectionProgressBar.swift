import SwiftUI

struct CollectionProgressBar: View {
    let current: Int
    let total: Int

    private var progress: Double {
        guard total > 0 else { return 0 }
        return Double(current) / Double(total)
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    var body: some View {
        VStack(spacing: StillwaterSpacing.xxs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: StillwaterRadius.full)
                        .fill(StillwaterColors.bgTertiary)

                    RoundedRectangle(cornerRadius: StillwaterRadius.full)
                        .fill(
                            LinearGradient(
                                colors: [StillwaterColors.sage, StillwaterColors.sky],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, geometry.size.width * progress))
                        .animation(StillwaterAnimation.slowEase, value: progress)
                }
            }
            .frame(height: 8)

            HStack {
                Spacer()
                Text("\(percentage)%")
                    .font(StillwaterFont.caption)
                    .foregroundStyle(StillwaterColors.textTertiary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CollectionProgressBar(current: 0, total: 8)
        CollectionProgressBar(current: 3, total: 8)
        CollectionProgressBar(current: 8, total: 8)
    }
    .padding()
}
