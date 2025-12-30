import SwiftUI

struct ToolkitHomeView: View {
    @Environment(AppState.self) private var appState

    @State private var showContent = false

    private let mainFeelings: [Feeling] = [.angry, .worried, .sad, .overwhelmed]
    private let secondaryFeelings: [Feeling] = [.cantSleep]

    var body: some View {
        ZStack {
            StillwaterGradients.daytime
                .ignoresSafeArea()

            VStack(spacing: StillwaterSpacing.xl) {
                Spacer()

                MiloCharacter(mood: .caring, size: .large)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.8)

                VStack(spacing: StillwaterSpacing.sm) {
                    Text("How are you feeling right now?")
                        .font(StillwaterFont.headlineLarge)
                        .foregroundStyle(StillwaterColors.textPrimary)

                    Text("I have some quick tricks to help.")
                        .font(StillwaterFont.bodyMedium)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
                .multilineTextAlignment(.center)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: StillwaterSpacing.md) {
                    ForEach(mainFeelings, id: \.self) { feeling in
                        FeelingOptionCard(feeling: feeling) {
                            navigateToProtocol(for: feeling)
                        }
                    }
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .opacity(showContent ? 1 : 0)

                HStack(spacing: StillwaterSpacing.md) {
                    ForEach(secondaryFeelings, id: \.self) { feeling in
                        FeelingOptionCard(feeling: feeling, style: .wide) {
                            navigateToProtocol(for: feeling)
                        }
                    }
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
                .opacity(showContent ? 1 : 0)

                Spacer()
            }
        }
        .navigationTitle("Toolkit")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(StillwaterAnimation.slowEase.delay(0.2)) {
                showContent = true
            }
        }
    }

    private func navigateToProtocol(for feeling: Feeling) {
        if let protocolItem = appState.contentService.toolkitProtocol(for: feeling) {
            appState.navigate(to: .toolkitProtocol(feeling: feeling, protocolId: protocolItem.id))
        }
    }
}

#Preview {
    NavigationStack {
        ToolkitHomeView()
            .environment(AppState())
    }
}
