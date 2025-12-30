import SwiftUI

struct ScreenContainer<Content: View>: View {
    let background: Background
    let content: Content

    enum Background {
        case daytime
        case evening
        case night
        case plain

        var gradient: LinearGradient {
            switch self {
            case .daytime: return StillwaterGradients.daytime
            case .evening: return StillwaterGradients.evening
            case .night: return StillwaterGradients.night
            case .plain: return LinearGradient(colors: [StillwaterColors.bgPrimary], startPoint: .top, endPoint: .bottom)
            }
        }
    }

    init(
        background: Background = .daytime,
        @ViewBuilder content: () -> Content
    ) {
        self.background = background
        self.content = content()
    }

    var body: some View {
        ZStack {
            background.gradient
                .ignoresSafeArea()

            content
        }
    }
}

#Preview {
    ScreenContainer(background: .daytime) {
        VStack {
            Text("Hello Stillwater")
                .font(StillwaterFont.displayMedium)
                .foregroundStyle(StillwaterColors.textPrimary)
        }
    }
}
