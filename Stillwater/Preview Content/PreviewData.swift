import Foundation

#if DEBUG
struct PreviewData {
    // MARK: - Sample Child Profile
    static let sampleChild = ChildProfile(
        id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
        name: "Emma",
        ageRange: .middle,
        avatarName: "avatar-1",
        gardenState: GardenState(plantGrowth: 0.35, plantsUnlocked: 3, lastWatered: Date()),
        completedSessionIds: [
            UUID(uuidString: "550e8400-e29b-41d4-a716-446655441001")!,
            UUID(uuidString: "550e8400-e29b-41d4-a716-446655441002")!,
            UUID(uuidString: "550e8400-e29b-41d4-a716-446655441003")!
        ],
        learnedSkillIds: [
            UUID(uuidString: "550e8400-e29b-41d4-a716-446655440101")!,
            UUID(uuidString: "550e8400-e29b-41d4-a716-446655440102")!
        ],
        createdAt: Date().addingTimeInterval(-86400 * 14)
    )

    // MARK: - Sample Sessions
    static let sampleSessions: [Session] = [
        Session(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655441001")!,
            childId: sampleChild.id,
            meditationId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            startedAt: Date().addingTimeInterval(-86400 * 2),
            completedAt: Date().addingTimeInterval(-86400 * 2 + 180),
            preFeeling: nil,
            postFeeling: .calm,
            completedFully: true
        ),
        Session(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655441002")!,
            childId: sampleChild.id,
            meditationId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440001")!,
            startedAt: Date().addingTimeInterval(-86400),
            completedAt: Date().addingTimeInterval(-86400 + 180),
            preFeeling: nil,
            postFeeling: .same,
            completedFully: true
        ),
        Session(
            id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655441003")!,
            childId: sampleChild.id,
            meditationId: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440002")!,
            startedAt: Date().addingTimeInterval(-3600),
            completedAt: Date().addingTimeInterval(-3600 + 240),
            preFeeling: nil,
            postFeeling: .calm,
            completedFully: true
        )
    ]

    // MARK: - Sample Skills
    static let sampleSkill = Skill(
        id: UUID(uuidString: "550e8400-e29b-41d4-a716-446655440101")!,
        name: "Balloon Breath",
        description: "Deep belly breathing that fills your tummy like a balloon.",
        category: .breath,
        iconName: "wind",
        technique: "Breathe in slowly through your nose, feeling your belly expand like a balloon.",
        useWhen: "You want to feel calm, before bed, when you're nervous",
        sortOrder: 1
    )

    // MARK: - Sample Weekly Stats
    static let sampleWeeklyStats = WeeklyStats(
        sessionsCompleted: 5,
        totalMinutes: 18,
        currentStreak: 3,
        skillsLearned: 2,
        mostPracticedCategory: .breath,
        dailyBreakdown: [
            .init(date: Date().addingTimeInterval(-86400 * 6), sessionCount: 1, minutes: 3),
            .init(date: Date().addingTimeInterval(-86400 * 5), sessionCount: 0, minutes: 0),
            .init(date: Date().addingTimeInterval(-86400 * 4), sessionCount: 1, minutes: 4),
            .init(date: Date().addingTimeInterval(-86400 * 3), sessionCount: 0, minutes: 0),
            .init(date: Date().addingTimeInterval(-86400 * 2), sessionCount: 1, minutes: 3),
            .init(date: Date().addingTimeInterval(-86400), sessionCount: 1, minutes: 4),
            .init(date: Date(), sessionCount: 1, minutes: 4)
        ]
    )

    // MARK: - Sample Skill Progress
    static let sampleSkillProgress = SkillProgress(
        breath: .init(learned: 2, total: 4),
        body: .init(learned: 1, total: 4),
        mind: .init(learned: 0, total: 4),
        heart: .init(learned: 0, total: 4)
    )
}
#endif
