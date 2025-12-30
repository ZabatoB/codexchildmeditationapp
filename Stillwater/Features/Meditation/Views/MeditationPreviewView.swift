import SwiftUI

struct MeditationPreviewView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let meditation: Meditation

    @State private var showContent = false

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.lg) {
                headerSection

                Spacer()

                contentSection

                miloSection

                Spacer()

                buttonSection
            }
            .padding(.top, StillwaterSpacing.md)
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: StillwaterSpacing.xxs) {
                    Image(systemName: StillwaterIcon.back)
                    Text("Back")
                }
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
            }
            Spacer()
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
    }

    private var contentSection: some View {
        VStack(spacing: StillwaterSpacing.lg) {
            ZStack {
                Circle()
                    .fill(meditation.category.color.opacity(0.15))
                    .frame(width: 100, height: 100)

                Image(systemName: meditation.category.iconName)
                    .font(.system(size: 44))
                    .foregroundStyle(meditation.category.color)
            }
            .opacity(showContent ? 1 : 0)
            .scaleEffect(showContent ? 1 : 0.8)

            VStack(spacing: StillwaterSpacing.xs) {
                Text(meditation.title)
                    .font(StillwaterFont.displaySmall)
                    .foregroundStyle(StillwaterColors.textPrimary)

                HStack(spacing: StillwaterSpacing.xs) {
                    Text(meditation.category.displayName)
                        .foregroundStyle(meditation.category.color)
                    Text("•")
                        .foregroundStyle(StillwaterColors.textTertiary)
                    Text("\(meditation.durationMinutes) min")
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
                .font(StillwaterFont.labelMedium)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)

            Text(meditation.description)
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, StillwaterSpacing.xl)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
        }
    }

    private var miloSection: some View {
        VStack(spacing: StillwaterSpacing.sm) {
            MiloCharacter(mood: .encouraging, size: .medium)

            Text(miloMessage)
                .font(StillwaterFont.miloSpeaking)
                .foregroundStyle(StillwaterColors.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, StillwaterSpacing.xl)
        }
        .opacity(showContent ? 1 : 0)
    }

    private var buttonSection: some View {
        VStack(spacing: StillwaterSpacing.md) {
            PrimaryButton("Begin Meditation", icon: StillwaterIcon.play) {
                appState.navigate(to: .meditationPlayer(meditationId: meditation.id))
            }

            GentleButton("I'll do this later") {
                dismiss()
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        .padding(.bottom, StillwaterSpacing.xxl)
        .opacity(showContent ? 1 : 0)
    }

    private var miloMessage: String {
        let messages = [
            "Ready when you are! Find a comfy spot.",
            "This is going to be great!",
            "Let's do this together!",
            "Find a quiet place and get comfortable."
        ]
        return messages.randomElement() ?? messages[0]
    }
}

#Preview {
    MeditationPreviewView(
        meditation: Meditation(
            id: UUID(),
            title: "Balloon Breath",
            description: "Learn to breathe deep into your belly like filling up a balloon. This calming technique helps you feel peaceful anytime.",
            shortDescription: "Deep belly breathing",
            durationMinutes: 3,
            category: .breath,
            ageRanges: [.young, .middle, .older],
            skillIds: [UUID()],
            thumbnailName: "balloon",
            isLocked: false,
            unlockAfterSessions: nil,
            sortOrder: 1,
            segments: []
        )
    )
    .environment(AppState())
}
