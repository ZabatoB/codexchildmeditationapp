import SwiftUI

struct FirstSkillEarnedView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    @State private var showCard = false
    @State private var showText = false
    @State private var showButton = false
    @State private var cardOffset: CGFloat = -300
    @State private var cardRotation: Double = -15

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            if showCard {
                CelebrationParticles()
            }

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                SkillCardLarge(
                    name: "Balloon Breath",
                    icon: "wind",
                    category: .breath,
                    isFirstSkill: true
                )
                .offset(y: cardOffset)
                .rotationEffect(.degrees(cardRotation))
                .opacity(showCard ? 1 : 0)

                VStack(spacing: StillwaterSpacing.sm) {
                    Text("You just learned your first Calm Card!")
                        .font(StillwaterFont.headlineMedium)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text("You can practice it anytime.")
                        .font(StillwaterFont.bodyLarge)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, StillwaterSpacing.lg)
                .opacity(showText ? 1 : 0)
                .offset(y: showText ? 0 : 20)

                Spacer()

                PrimaryButton("See My Space") {
                    viewModel.goToNextStep()
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .padding(.bottom, StillwaterSpacing.xxl)
                .opacity(showButton ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                showCard = true
                cardOffset = 0
                cardRotation = 0
            }

            withAnimation(StillwaterAnimation.slowEase.delay(1.0)) {
                showText = true
            }

            withAnimation(StillwaterAnimation.slowEase.delay(1.4)) {
                showButton = true
            }
        }
    }
}

struct SkillCardLarge: View {
    let name: String
    let icon: String
    let category: Meditation.Category
    let isFirstSkill: Bool

    var body: some View {
        VStack(spacing: StillwaterSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundStyle(category.color)
                .frame(width: 80, height: 80)
                .background(category.color.opacity(0.15))
                .clipShape(Circle())

            Text(name)
                .font(StillwaterFont.headlineLarge)
                .foregroundStyle(StillwaterColors.textPrimary)

            if isFirstSkill {
                Text("Your first skill!")
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.sage)
                    .padding(.horizontal, StillwaterSpacing.md)
                    .padding(.vertical, StillwaterSpacing.xs)
                    .background(StillwaterColors.sage.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(StillwaterSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: StillwaterRadius.xlarge)
                .fill(Color.white)
                .shadow(color: StillwaterColors.sage.opacity(0.3), radius: 20, y: 10)
        )
    }
}

struct CelebrationParticles: View {
    @State private var particles: [Particle] = []

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(x: particle.x, y: particle.y)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
        }
    }

    private func createParticles() {
        let colors: [Color] = [
            StillwaterColors.sage,
            StillwaterColors.sky,
            StillwaterColors.lavender,
            StillwaterColors.sunrise
        ]

        for i in 0..<20 {
            let particle = Particle(
                id: i,
                x: CGFloat.random(in: -150...150),
                y: CGFloat.random(in: -200...200),
                size: CGFloat.random(in: 4...12),
                color: colors.randomElement()!.opacity(0.6),
                opacity: 1
            )
            particles.append(particle)

            withAnimation(.easeOut(duration: 2).delay(Double(i) * 0.05)) {
                particles[i].opacity = 0
            }
        }
    }

    struct Particle: Identifiable {
        let id: Int
        var x: CGFloat
        var y: CGFloat
        var size: CGFloat
        var color: Color
        var opacity: Double
    }
}

#Preview {
    FirstSkillEarnedView()
        .environment(OnboardingViewModel())
}
