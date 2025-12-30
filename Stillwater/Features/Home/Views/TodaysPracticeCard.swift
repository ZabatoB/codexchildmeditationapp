import SwiftUI

struct TodaysPracticeCard: View {
    let meditation: Meditation
    let isCompleted: Bool
    let nextUnlock: UnlockPreview?
    let onPlay: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ContentCard {
                HStack(spacing: StillwaterSpacing.md) {
                    ZStack {
                        Circle()
                            .fill(meditation.category.color.opacity(0.15))
                            .frame(width: 56, height: 56)

                        Image(systemName: meditation.category.iconName)
                            .font(.system(size: 24))
                            .foregroundStyle(meditation.category.color)
                    }

                    VStack(alignment: .leading, spacing: StillwaterSpacing.xxs) {
                        Text(meditation.title)
                            .font(StillwaterFont.headlineSmall)
                            .foregroundStyle(StillwaterColors.textPrimary)

                        HStack(spacing: StillwaterSpacing.xs) {
                            Text("\(meditation.durationMinutes) min")
                                .font(StillwaterFont.labelSmall)
                                .foregroundStyle(StillwaterColors.textSecondary)

                            Text("•")
                                .foregroundStyle(StillwaterColors.textTertiary)

                            Text(meditation.category.displayName)
                                .font(StillwaterFont.labelSmall)
                                .foregroundStyle(meditation.category.color)
                        }

                        if isCompleted {
                            HStack(spacing: StillwaterSpacing.xxs) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                Text("Done today")
                                    .font(StillwaterFont.labelSmall)
                            }
                            .foregroundStyle(StillwaterColors.sage)
                        }
                    }

                    Spacer()

                    Button(action: onPlay) {
                        Image(systemName: StillwaterIcon.play)
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                            .frame(width: 52, height: 52)
                            .background(StillwaterColors.sage)
                            .clipShape(Circle())
                            .stillwaterShadow(.soft)
                    }
                }
            }

            if let unlock = nextUnlock {
                NextUnlockBanner(unlock: unlock)
                    .padding(.top, StillwaterSpacing.xs)
            }
        }
    }
}

struct NextUnlockBanner: View {
    let unlock: UnlockPreview

    var body: some View {
        HStack(spacing: StillwaterSpacing.xs) {
            Image(systemName: "star.fill")
                .font(.system(size: 12))
                .foregroundStyle(StillwaterColors.sunrise)

            Text("\(unlock.sessionsRemaining) more \(unlock.sessionsRemaining == 1 ? "session" : "sessions") to unlock \(unlock.title)")
                .font(StillwaterFont.labelSmall)
                .foregroundStyle(StillwaterColors.textSecondary)

            Spacer()
        }
        .padding(.horizontal, StillwaterSpacing.md)
        .padding(.vertical, StillwaterSpacing.xs)
        .background(StillwaterColors.sunrise.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.small))
    }
}

#Preview {
    VStack(spacing: 20) {
        TodaysPracticeCard(
            meditation: Meditation(
                id: UUID(),
                title: "Balloon Breath",
                description: "Learn to breathe deeply",
                shortDescription: "Deep breathing",
                durationMinutes: 3,
                category: .breath,
                ageRanges: [.middle],
                skillIds: [],
                thumbnailName: "balloon",
                isLocked: false,
                unlockAfterSessions: nil,
                sortOrder: 1,
                segments: []
            ),
            isCompleted: false,
            nextUnlock: UnlockPreview(
                type: .meditation,
                title: "Sound Safari",
                sessionsRequired: 5,
                sessionsRemaining: 2
            ),
            onPlay: {}
        )

        TodaysPracticeCard(
            meditation: Meditation(
                id: UUID(),
                title: "Squeeze and Let Go",
                description: "Muscle relaxation",
                shortDescription: "Body relaxation",
                durationMinutes: 4,
                category: .body,
                ageRanges: [.middle],
                skillIds: [],
                thumbnailName: "squeeze",
                isLocked: false,
                unlockAfterSessions: nil,
                sortOrder: 2,
                segments: []
            ),
            isCompleted: true,
            nextUnlock: nil,
            onPlay: {}
        )
    }
    .padding()
}
