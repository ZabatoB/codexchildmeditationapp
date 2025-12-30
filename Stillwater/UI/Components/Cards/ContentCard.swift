import SwiftUI

struct ContentCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(StillwaterSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(StillwaterColors.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.large))
            .stillwaterShadow(.soft)
    }
}

#Preview {
    ContentCard {
        VStack(alignment: .leading, spacing: StillwaterSpacing.xs) {
            Text("Balloon Breath")
                .font(StillwaterFont.headlineMedium)
                .foregroundStyle(StillwaterColors.textPrimary)
            Text("Learn to breathe deep into your belly")
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(StillwaterColors.textSecondary)
        }
    }
    .padding()
}
