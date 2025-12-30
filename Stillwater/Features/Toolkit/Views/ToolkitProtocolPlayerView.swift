import SwiftUI

struct ToolkitProtocolPlayerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let feeling: Feeling
    let protocolId: UUID

    @State private var coordinator = MeditationPlaybackCoordinator()
    @State private var showExitConfirmation = false
    @State private var toolkitUsage: ToolkitUsage?

    private var protocolItem: ToolkitProtocol? {
        appState.contentService.allProtocols.first { $0.id == protocolId }
            ?? appState.contentService.toolkitProtocol(for: feeling)
    }

    var body: some View {
        ZStack {
            ToolkitBackground(feeling: feeling, breathPhase: coordinator.breathPhase)

            VStack(spacing: 0) {
                headerSection

                Spacer()

                visualSection

                MiloCharacter(mood: coordinator.miloMood, size: .medium)
                    .padding(.top, StillwaterSpacing.lg)

                Text(coordinator.currentText)
                    .font(StillwaterFont.miloSpeaking)
                    .foregroundStyle(StillwaterColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StillwaterSpacing.xl)
                    .frame(minHeight: 80)
                    .animation(.easeInOut(duration: 0.3), value: coordinator.currentText)

                Spacer()

                PlayerProgressIndicator(
                    current: coordinator.currentSegmentIndex,
                    total: coordinator.totalSegments
                )
                .padding(.bottom, StillwaterSpacing.xxl)
            }

            if coordinator.showFeelingCheck {
                toolkitFeelingCheckOverlay
            }

            if showExitConfirmation {
                exitConfirmationOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            startProtocol()
        }
        .onDisappear {
            coordinator.stop()
        }
        .onChange(of: coordinator.isComplete) { _, complete in
            if complete {
                navigateToComplete()
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(protocolItem?.title ?? "")
                    .font(StillwaterFont.headlineSmall)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("for when you're \(feeling.displayName.lowercased())")
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }

            Spacer()

            Button {
                coordinator.pause()
                showExitConfirmation = true
            } label: {
                Image(systemName: StillwaterIcon.close)
                    .font(.system(size: 18))
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .frame(width: 40, height: 40)
                    .background(StillwaterColors.bgPrimary.opacity(0.6))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, StillwaterSpacing.screenHorizontal)
        .padding(.top, StillwaterSpacing.md)
    }

    private var visualSection: some View {
        BreathingCircle(
            phase: coordinator.breathPhase,
            size: 180,
            color: feeling.color
        )
        .frame(height: 200)
    }

    private var toolkitFeelingCheckOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            ToolkitResultSelector(
                originalFeeling: feeling,
                options: resultFeelingOptions,
                onSelect: { resultFeeling in
                    coordinator.selectFeeling(resultFeeling)
                    toolkitUsage?.resultFeeling = resultFeeling
                }
            )
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
                    abandonUsage()
                    dismiss()
                }
            )
        }
        .transition(.opacity)
    }

    private var resultFeelingOptions: [Feeling] {
        switch feeling {
        case .angry:
            return [.better, .littleBetter, .stillAngry]
        case .worried:
            return [.better, .littleBetter, .stillWorried]
        case .sad:
            return [.better, .littleBetter, .stillSad]
        case .overwhelmed:
            return [.better, .littleBetter, .stillOverwhelmed]
        case .cantSleep:
            return [.better, .littleBetter, .stillCantSleep]
        default:
            return [.better, .littleBetter, .same]
        }
    }

    private func startProtocol() {
        guard let protocolItem = protocolItem,
              let child = appState.currentChild else { return }

        toolkitUsage = ToolkitUsage(
            childId: child.id,
            protocolId: protocolItem.id,
            initialFeeling: feeling
        )

        let mockMeditation = Meditation(
            id: protocolItem.id,
            title: protocolItem.title,
            description: protocolItem.description,
            shortDescription: "",
            durationMinutes: protocolItem.durationMinutes,
            category: .breath,
            ageRanges: [.young, .middle, .older],
            skillIds: [],
            thumbnailName: "",
            isLocked: false,
            unlockAfterSessions: nil,
            sortOrder: 0,
            segments: protocolItem.segments
        )

        coordinator.start(meditation: mockMeditation)
    }

    private func navigateToComplete() {
        guard var usage = toolkitUsage else {
            appState.navigateBack()
            return
        }

        usage.complete(resultFeeling: coordinator.selectedFeeling)
        appState.storageService.saveToolkitUsage(usage)

        appState.navigate(to: .toolkitComplete(
            feeling: feeling,
            resultFeeling: coordinator.selectedFeeling
        ))
    }

    private func abandonUsage() {
        guard var usage = toolkitUsage else { return }
        usage.completedAt = Date()
        usage.completedFully = false
        appState.storageService.saveToolkitUsage(usage)
    }
}

struct ToolkitBackground: View {
    let feeling: Feeling
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
        let baseColor = feeling.color

        switch breathPhase {
        case .inhale:
            return [baseColor.opacity(0.15), baseColor.opacity(0.05)]
        case .exhale:
            return [StillwaterColors.bgPrimary, baseColor.opacity(0.1)]
        default:
            return [StillwaterColors.bgPrimary, baseColor.opacity(0.08)]
        }
    }
}

#Preview {
    ToolkitProtocolPlayerView(
        feeling: .angry,
        protocolId: UUID()
    )
    .environment(AppState())
}
