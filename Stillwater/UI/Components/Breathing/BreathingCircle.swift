import SwiftUI

struct BreathingCircle: View {
    let phase: Phase
    var size: CGFloat = 200
    var color: Color = StillwaterColors.sky
    var showText: Bool = false
    var inhaleText: String = "Breathe in"
    var exhaleText: String = "Breathe out"

    enum Phase: Equatable {
        case idle
        case inhale(duration: TimeInterval)
        case hold(duration: TimeInterval)
        case exhale(duration: TimeInterval)

        var targetScale: CGFloat {
            switch self {
            case .idle: return 0.7
            case .inhale: return 1.0
            case .hold: return 1.0
            case .exhale: return 0.7
            }
        }

        var duration: TimeInterval {
            switch self {
            case .idle: return 0.5
            case .inhale(let duration), .hold(let duration), .exhale(let duration): return duration
            }
        }

        var isBreathing: Bool {
            switch self {
            case .idle: return false
            default: return true
            }
        }
    }

    @State private var currentScale: CGFloat = 0.7
    @State private var glowOpacity: Double = 0.3
    @State private var innerGlow: Double = 0.2

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(glowOpacity))
                .frame(width: size * 1.4, height: size * 1.4)
                .blur(radius: 25)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            color.opacity(0.9),
                            color.opacity(0.5),
                            color.opacity(0.3)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size / 2
                    )
                )
                .frame(width: size, height: size)
                .scaleEffect(currentScale)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            .white.opacity(innerGlow),
                            .clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.3
                    )
                )
                .frame(width: size * 0.6, height: size * 0.6)
                .scaleEffect(currentScale)

            if showText {
                Text(textForPhase)
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(.white.opacity(0.9))
                    .animation(.easeInOut(duration: 0.3), value: phase)
            }
        }
        .onChange(of: phase) { _, newPhase in
            animateToPhase(newPhase)
        }
        .onAppear {
            currentScale = phase.targetScale
        }
    }

    private var textForPhase: String {
        switch phase {
        case .inhale: return inhaleText
        case .exhale: return exhaleText
        case .hold: return "Hold"
        case .idle: return ""
        }
    }

    private func animateToPhase(_ newPhase: Phase) {
        let duration = newPhase.duration

        withAnimation(.easeInOut(duration: duration)) {
            currentScale = newPhase.targetScale
        }

        withAnimation(.easeInOut(duration: duration / 2)) {
            switch newPhase {
            case .inhale:
                glowOpacity = 0.5
                innerGlow = 0.4
            case .hold:
                glowOpacity = 0.45
                innerGlow = 0.35
            case .exhale:
                glowOpacity = 0.25
                innerGlow = 0.15
            case .idle:
                glowOpacity = 0.3
                innerGlow = 0.2
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        BreathingCircle(phase: .idle, size: 150)
        BreathingCircle(phase: .inhale(duration: 4), size: 150)
        BreathingCircle(phase: .exhale(duration: 4), size: 150, showText: true)
    }
    .padding()
    .background(Color(hex: "FDFBF7"))
}
