import SwiftUI

struct ToolkitCompleteView: View {
    @Environment(AppState.self) private var appState

    let feeling: Feeling
    let resultFeeling: Feeling?

    @State private var showContent = false

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                MiloCharacter(mood: miloMood, size: .large)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)

                VStack(spacing: StillwaterSpacing.sm) {
                    Text(headerText)
                        .font(StillwaterFont.headlineLarge)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text(messageText)
                        .font(StillwaterFont.bodyMedium)
                        .foregroundStyle(StillwaterColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, StillwaterSpacing.lg)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Spacer()

                VStack(spacing: StillwaterSpacing.sm) {
                    PrimaryButton("Return Home") {
                        appState.navigateToRoot()
                    }

                    if resultFeeling != .better {
                        GentleButton("Try another technique") {
                            appState.navigateBack()
                            appState.navigateBack()
                            appState.navigateBack()
                        }
                    }
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .padding(.bottom, StillwaterSpacing.xxl)
                .opacity(showContent ? 1 : 0)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }

    private var miloMood: MiloCharacter.Mood {
        switch resultFeeling {
        case .better:
            return .happy
        case .littleBetter:
            return .encouraging
        default:
            return .caring
        }
    }

    private var headerText: String {
        switch resultFeeling {
        case .better:
            return "Wonderful!"
        case .littleBetter:
            return "That's progress!"
        default:
            return "It's okay"
        }
    }

    private var messageText: String {
        switch resultFeeling {
        case .better:
            return "You did great! Remember, you can use this technique anytime you feel \(feeling.displayName.lowercased())."
        case .littleBetter:
            return "Even a little better is good! Sometimes it takes a few tries. You're doing great."
        default:
            return "Some feelings take time. It's okay to still feel \(feeling.displayName.lowercased()). Would you like to try something else?"
        }
    }
}

#Preview {
    ToolkitCompleteView(
        feeling: .angry,
        resultFeeling: .better
    )
    .environment(AppState())
}
