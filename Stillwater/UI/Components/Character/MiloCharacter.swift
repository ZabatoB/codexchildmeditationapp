import SwiftUI

struct MiloCharacter: View {
    let mood: Mood
    let size: Size
    let isAnimated: Bool

    @State private var isBreathing = false
    @State private var isWaving = false

    enum Mood {
        case neutral
        case happy
        case sleepy
        case breathing
        case waving
        case curious
        case encouraging
        case peaceful
        case caring
    }

    enum Size {
        case small
        case medium
        case large
        case hero

        var dimension: CGFloat {
            switch self {
            case .small: return 60
            case .medium: return 100
            case .large: return 160
            case .hero: return 200
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .small: return 30
            case .medium: return 50
            case .large: return 80
            case .hero: return 100
            }
        }
    }

    init(mood: Mood = .neutral, size: Size = .medium, isAnimated: Bool = true) {
        self.mood = mood
        self.size = size
        self.isAnimated = isAnimated
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(StillwaterColors.sage.opacity(0.2))
                .frame(width: size.dimension, height: size.dimension)
                .scaleEffect(isBreathing ? 1.05 : 1.0)

            Text(moodEmoji)
                .font(.system(size: size.fontSize))
                .scaleEffect(isWaving ? 1.1 : 1.0)
                .rotationEffect(isWaving ? .degrees(10) : .degrees(0))
        }
        .onAppear {
            if isAnimated {
                startAnimations()
            }
        }
    }

    private var moodEmoji: String {
        switch mood {
        case .neutral: return "🦥"
        case .happy: return "🦥"
        case .sleepy: return "😴"
        case .breathing: return "🦥"
        case .waving: return "👋"
        case .curious: return "🤔"
        case .encouraging: return "🦥"
        case .peaceful: return "😌"
        case .caring: return "🤗"
        }
    }

    private func startAnimations() {
        switch mood {
        case .breathing:
            withAnimation(
                Animation.easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
            ) {
                isBreathing = true
            }
        case .waving:
            withAnimation(
                Animation.easeInOut(duration: 0.5)
                    .repeatCount(3, autoreverses: true)
            ) {
                isWaving = true
            }
        default:
            break
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 20) {
            MiloCharacter(mood: .neutral, size: .small)
            MiloCharacter(mood: .happy, size: .small)
            MiloCharacter(mood: .sleepy, size: .small)
        }

        MiloCharacter(mood: .breathing, size: .large)

        MiloCharacter(mood: .waving, size: .hero)
    }
    .padding()
}
