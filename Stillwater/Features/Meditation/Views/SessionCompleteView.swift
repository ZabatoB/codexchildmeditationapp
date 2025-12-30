import SwiftUI

struct SessionCompleteView: View {
    @Environment(AppState.self) private var appState

    let meditationId: UUID
    let earnedSkillId: UUID?
    let feeling: Feeling?

    @State private var showContent = false
    @State private var showCard = false
    @State private var showGarden = false
    @State private var cardOffset: CGFloat = -200

    private var meditation: Meditation? {
        appState.contentService.meditation(id: meditationId)
    }

    private var skill: Skill? {
        guard let skillId = earnedSkillId else { return nil }
        return appState.contentService.skill(id: skillId)
    }

    private var childName: String {
        appState.currentChild?.name ?? "Friend"
    }

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            if showContent {
                MeditationCelebrationParticles()
            }

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                MiloCharacter(mood: .happy, size: .large)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.5)

                Text("Great job, \(childName)!")
                    .font(StillwaterFont.displaySmall)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .opacity(showContent ? 1 : 0)

                if let skill = skill {
                    SkillEarnedCard(skill: skill)
                        .offset(y: cardOffset)
                        .opacity(showCard ? 1 : 0)
                }

                GardenGrowthCard()
                    .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                    .opacity(showGarden ? 1 : 0)
                    .offset(y: showGarden ? 0 : 20)

                Spacer()

                VStack(spacing: StillwaterSpacing.sm) {
                    PrimaryButton("Return Home") {
                        appState.navigateToRoot()
                    }

                    GentleButton("Practice Again") {
                        appState.navigateBack()
                        appState.navigateBack()
                    }
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .padding(.bottom, StillwaterSpacing.xxl)
                .opacity(showContent ? 1 : 0)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            runAnimationSequence()
        }
    }

    private func runAnimationSequence() {
        withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
            showContent = true
        }

        if skill != nil {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6)) {
                showCard = true
                cardOffset = 0
            }
        }

        withAnimation(StillwaterAnimation.slowEase.delay(skill != nil ? 1.2 : 0.6)) {
            showGarden = true
        }
    }
}

struct SkillEarnedCard: View {
    let skill: Skill

    var body: some View {
        VStack(spacing: StillwaterSpacing.sm) {
            ZStack {
                Circle()
                    .fill(skill.category.color.opacity(0.15))
                    .frame(width: 70, height: 70)

                Image(systemName: skill.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(skill.category.color)
            }

            Text(skill.name)
                .font(StillwaterFont.headlineMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            Text("Skill earned!")
                .font(StillwaterFont.labelSmall)
                .foregroundStyle(StillwaterColors.sage)
                .padding(.horizontal, StillwaterSpacing.md)
                .padding(.vertical, StillwaterSpacing.xxs)
                .background(StillwaterColors.sage.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(StillwaterSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: StillwaterRadius.large)
                .fill(StillwaterColors.bgPrimary)
                .shadow(color: StillwaterColors.sage.opacity(0.2), radius: 15, y: 5)
        )
    }
}

struct GardenGrowthCard: View {
    var body: some View {
        HStack(spacing: StillwaterSpacing.md) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 24))
                .foregroundStyle(StillwaterColors.sage)

            Text("Your garden grew a little!")
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            Spacer()
        }
        .padding(StillwaterSpacing.md)
        .background(StillwaterColors.sage.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
    }
}

struct MeditationCelebrationParticles: View {
    @State private var particles: [MeditationCelebrationParticle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }

    private func createParticles(in size: CGSize) {
        let colors: [Color] = [
            StillwaterColors.sage.opacity(0.6),
            StillwaterColors.sky.opacity(0.6),
            StillwaterColors.lavender.opacity(0.6),
            StillwaterColors.sunrise.opacity(0.6)
        ]

        for i in 0..<25 {
            let particle = MeditationCelebrationParticle(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: size.height * 0.3...size.height * 0.7)
                ),
                size: CGFloat.random(in: 6...14),
                color: colors.randomElement()!,
                opacity: 1.0
            )

            particles.append(particle)

            let index = particles.count - 1
            withAnimation(.easeOut(duration: 2.5).delay(Double(i) * 0.05)) {
                particles[index].opacity = 0
            }
        }
    }
}

struct MeditationCelebrationParticle: Identifiable {
    let id: Int
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
}

#Preview {
    SessionCompleteView(
        meditationId: UUID(),
        earnedSkillId: UUID(),
        feeling: .calm
    )
    .environment(AppState())
}
