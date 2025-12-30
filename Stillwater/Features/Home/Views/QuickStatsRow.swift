import SwiftUI

struct QuickStatsRow: View {
    let streak: Int
    let minutes: Int
    let skills: Int

    var body: some View {
        HStack(spacing: StillwaterSpacing.sm) {
            StatCard(
                icon: "flame.fill",
                value: "\(streak)",
                label: streak == 1 ? "day" : "days",
                color: StillwaterColors.sunrise
            )

            StatCard(
                icon: "clock.fill",
                value: "\(minutes)",
                label: "min this week",
                color: StillwaterColors.sky
            )

            StatCard(
                icon: "square.stack.fill",
                value: "\(skills)",
                label: skills == 1 ? "skill" : "skills",
                color: StillwaterColors.sage
            )
        }
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: StillwaterSpacing.xxs) {
            HStack(spacing: StillwaterSpacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)

                Text(value)
                    .font(StillwaterFont.headlineMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)
            }

            Text(label)
                .font(StillwaterFont.caption)
                .foregroundStyle(StillwaterColors.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, StillwaterSpacing.sm)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
    }
}

#Preview {
    QuickStatsRow(streak: 3, minutes: 12, skills: 2)
        .padding()
}
