import SwiftUI

struct MeditationPlayerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let meditation: Meditation

    @State private var coordinator = MeditationPlaybackCoordinator()
    @State private var showExitConfirmation = false
    @State private var session: Session?
    @State private var idlePulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            MeditationBackground(breathPhase: coordinator.breathPhase)

            VStack(spacing: 0) {
                closeButton

                Spacer()

                visualSection

                miloSection

                guidanceTextSection

                Spacer()

                progressSection
            }

            if coordinator.showFeelingCheck {
                feelingCheckOverlay
            }

            if showExitConfirmation {
                exitConfirmationOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startMeditation()
        }
        .onDisappear {
            coordinator.stop()
        }
        .onChange(of: coordinator.isComplete) { _, complete in
            if complete {
                completeSession()
            }
        }
    }

    private var closeButton: some View {
        HStack {
            Spacer()

            Button {
                coordinator.pause()
                showExitConfirmation = true
            } label: {
                Image(systemName: StillwaterIcon.close)
                    .font(.system(size: 20))
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .frame(width: 44, height: 44)
                    .background(StillwaterColors.bgPrimary.opacity(0.5))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        .padding(.top, StillwaterSpacing.md)
    }

    private var visualSection: some View {
        Group {
            switch coordinator.visualCue {
            case .breathingCircle, .breatheIn, .breatheOut:
                BreathingCircle(
                    phase: coordinator.breathPhase,
                    size: 200,
                    color: StillwaterColors.sky
                )
            case .squeezeFists, .holdTension, .release:
                BodyActionVisual(action: coordinator.visualCue)
            default:
                Circle()
                    .fill(StillwaterColors.sage.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(idlePulseScale)
                    .animation(
                        Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                        value: idlePulseScale
                    )
            }
        }
        .frame(height: 220)
    }

    private var miloSection: some View {
        MiloCharacter(mood: coordinator.miloMood, size: .medium)
            .padding(.top, StillwaterSpacing.lg)
    }

    private var guidanceTextSection: some View {
        Text(coordinator.currentText)
            .font(StillwaterFont.miloSpeaking)
            .foregroundStyle(StillwaterColors.textPrimary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, StillwaterSpacing.xl)
            .frame(minHeight: 80)
            .animation(.easeInOut(duration: 0.3), value: coordinator.currentText)
    }

    private var progressSection: some View {
        PlayerProgressIndicator(
            current: coordinator.currentSegmentIndex,
            total: coordinator.totalSegments
        )
        .padding(.bottom, StillwaterSpacing.xxl)
    }

    private var feelingCheckOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.lg) {
                Text("How does your body feel right now?")
                    .font(StillwaterFont.headlineMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)

                FeelingSelector(
                    selected: .constant(nil),
                    options: coordinator.feelingOptions,
                    style: .horizontal,
                    onSelect: { feeling in
                        coordinator.selectFeeling(feeling)
                    }
                )
            }
            .padding(StillwaterSpacing.xl)
            .background(StillwaterColors.bgPrimary)
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.xlarge))
            .padding(StillwaterSpacing.lg)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    private var exitConfirmationOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showExitConfirmation = false
                    coordinator.resume()
                }

            ExitConfirmationDialog(
                onContinue: {
                    showExitConfirmation = false
                    coordinator.resume()
                },
                onExit: {
                    abandonSession()
                    dismiss()
                }
            )
        }
        .transition(.opacity)
    }

    private func startMeditation() {
        if let child = appState.currentChild {
            session = Session(
                childId: child.id,
                meditationId: meditation.id,
                startedAt: Date(),
                completedFully: false
            )
        }

        withAnimation {
            idlePulseScale = 1.05
        }

        coordinator.start(meditation: meditation)
    }

    private func completeSession() {
        guard var completedSession = session else {
            navigateToComplete()
            return
        }

        completedSession.completedAt = Date()
        completedSession.completedFully = true
        completedSession.postFeeling = coordinator.selectedFeeling

        appState.storageService.saveSession(completedSession)

        if var child = appState.currentChild {
            appState.progressService.recordSession(completedSession, for: &child)

            if let skillId = coordinator.earnedSkillId,
               !child.learnedSkillIds.contains(skillId) {
                child.learnedSkillIds.append(skillId)
            }

            appState.updateCurrentChild(child)
        }

        navigateToComplete()
    }

    private func abandonSession() {
        guard var abandonedSession = session else { return }

        abandonedSession.completedAt = Date()
        abandonedSession.completedFully = false

        appState.storageService.saveSession(abandonedSession)
    }

    private func navigateToComplete() {
        appState.navigate(to: .sessionComplete(
            meditationId: meditation.id,
            earnedSkillId: coordinator.earnedSkillId,
            feeling: coordinator.selectedFeeling
        ))
    }
}

struct MeditationBackground: View {
    let breathPhase: BreathingCircle.Phase

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 2), value: breathPhase)
    }

    private var gradientColors: [Color] {
        switch breathPhase {
        case .inhale:
            return [Color(hex: "E8F4F8"), Color(hex: "D4E8E0")]
        case .exhale:
            return [Color(hex: "F0E8E4"), Color(hex: "E8DFD0")]
        case .hold:
            return [Color(hex: "E8E8F4"), Color(hex: "DFE0E8")]
        default:
            return [Color(hex: "FDFBF7"), Color(hex: "F5F1EA")]
        }
    }
}

struct BodyActionVisual: View {
    let action: MeditationSegment.VisualCue

    var body: some View {
        VStack(spacing: StillwaterSpacing.sm) {
            Image(systemName: iconForAction)
                .font(.system(size: 60))
                .foregroundStyle(colorForAction)

            Text(labelForAction)
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
        }
    }

    private var iconForAction: String {
        switch action {
        case .squeezeFists: return "hand.raised.fingers.spread.fill"
        case .holdTension: return "hand.raised.fill"
        case .release: return "hand.raised"
        default: return "figure.stand"
        }
    }

    private var colorForAction: Color {
        switch action {
        case .squeezeFists, .holdTension: return StillwaterColors.sunrise
        case .release: return StillwaterColors.sage
        default: return StillwaterColors.sky
        }
    }

    private var labelForAction: String {
        switch action {
        case .squeezeFists: return "Squeeze tight!"
        case .holdTension: return "Keep holding..."
        case .release: return "Let go..."
        default: return ""
        }
    }
}

struct PlayerProgressIndicator: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: StillwaterSpacing.xxs) {
            ForEach(0..<min(total, 12), id: \.self) { index in
                Circle()
                    .fill(index <= current ? StillwaterColors.sage : StillwaterColors.sage.opacity(0.3))
                    .frame(width: 8, height: 8)
            }

            if total > 12 {
                Text("...")
                    .font(StillwaterFont.caption)
                    .foregroundStyle(StillwaterColors.sage.opacity(0.5))
            }
        }
    }
}

struct ExitConfirmationDialog: View {
    let onContinue: () -> Void
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: StillwaterSpacing.lg) {
            MiloCharacter(mood: .curious, size: .medium)

            Text("Leave meditation?")
                .font(StillwaterFont.headlineMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            Text("You're doing great! Are you sure you want to stop?")
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: StillwaterSpacing.sm) {
                PrimaryButton("Keep Going") {
                    onContinue()
                }

                GentleButton("Exit") {
                    onExit()
                }
            }
        }
        .padding(StillwaterSpacing.xl)
        .background(StillwaterColors.bgPrimary)
        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.xlarge))
        .stillwaterShadow(.lifted)
        .padding(StillwaterSpacing.xl)
    }
}

#Preview {
    MeditationPlayerView(
        meditation: Meditation(
            id: UUID(),
            title: "Balloon Breath",
            description: "Deep belly breathing",
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
        )
    )
    .environment(AppState())
}
