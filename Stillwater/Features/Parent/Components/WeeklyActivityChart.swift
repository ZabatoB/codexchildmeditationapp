import SwiftUI

struct WeeklyActivityChart: View {
    let days: [WeeklyPracticeData.DayPractice]

    private let dayLabels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack(spacing: StillwaterSpacing.xs) {
            ForEach(Array(zip(dayLabels.indices, dayLabels)), id: \.0) { index, label in
                VStack(spacing: StillwaterSpacing.xxs) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(activityColor(for: index))
                        .frame(width: 28, height: activityHeight(for: index))
                        .frame(height: 40, alignment: .bottom)

                    Text(label)
                        .font(StillwaterFont.caption)
                        .foregroundStyle(StillwaterColors.textTertiary)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func activityColor(for index: Int) -> Color {
        guard index < days.count else {
            return StillwaterColors.bgTertiary
        }
        return days[index].hasActivity ? StillwaterColors.sage : StillwaterColors.bgTertiary
    }

    private func activityHeight(for index: Int) -> CGFloat {
        guard index < days.count else { return 8 }

        let day = days[index]
        if day.sessionCount == 0 { return 8 }

        let height = min(40, max(16, CGFloat(day.minutes) * 3))
        return height
    }
}

#Preview {
    WeeklyActivityChart(days: [
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 1, minutes: 3),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 0, minutes: 0),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 2, minutes: 7),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 1, minutes: 4),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 0, minutes: 0),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 1, minutes: 5),
        WeeklyPracticeData.DayPractice(date: Date(), sessionCount: 1, minutes: 3)
    ])
    .padding()
}
