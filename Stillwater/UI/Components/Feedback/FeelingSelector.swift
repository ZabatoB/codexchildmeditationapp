import SwiftUI

struct FeelingSelector: View {
    @Binding var selected: Feeling?
    let options: [Feeling]
    var style: Style = .horizontal
    var onSelect: ((Feeling) -> Void)? = nil

    enum Style {
        case horizontal
        case grid
    }

    var body: some View {
        Group {
            switch style {
            case .horizontal:
                horizontalLayout
            case .grid:
                gridLayout
            }
        }
    }

    private var horizontalLayout: some View {
        HStack(spacing: StillwaterSpacing.md) {
            ForEach(options, id: \.self) { feeling in
                FeelingButton(
                    feeling: feeling,
                    isSelected: selected == feeling,
                    style: .large
                ) {
                    withAnimation(StillwaterAnimation.softBounce) {
                        selected = feeling
                    }
                    onSelect?(feeling)
                }
            }
        }
    }

    private var gridLayout: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: StillwaterSpacing.sm) {
            ForEach(options, id: \.self) { feeling in
                FeelingButton(
                    feeling: feeling,
                    isSelected: selected == feeling,
                    style: .card
                ) {
                    withAnimation(StillwaterAnimation.softBounce) {
                        selected = feeling
                    }
                    onSelect?(feeling)
                }
            }
        }
    }
}

struct FeelingButton: View {
    let feeling: Feeling
    let isSelected: Bool
    let style: Style
    let action: () -> Void

    enum Style {
        case large
        case card
    }

    var body: some View {
        Button(action: action) {
            switch style {
            case .large:
                largeContent
            case .card:
                cardContent
            }
        }
    }

    private var largeContent: some View {
        VStack(spacing: StillwaterSpacing.xs) {
            Text(feeling.emoji)
                .font(.system(size: 44))

            Text(feeling.displayName)
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(isSelected ? feeling.color : StillwaterColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(StillwaterSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: StillwaterRadius.large)
                .fill(isSelected ? feeling.color.opacity(0.15) : StillwaterColors.bgTertiary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: StillwaterRadius.large)
                .strokeBorder(isSelected ? feeling.color : .clear, lineWidth: 2)
        )
    }

    private var cardContent: some View {
        HStack(spacing: StillwaterSpacing.sm) {
            Text(feeling.emoji)
                .font(.system(size: 32))

            Text(feeling.displayName)
                .font(StillwaterFont.bodyMedium)
                .foregroundStyle(isSelected ? feeling.color : StillwaterColors.textPrimary)

            Spacer()
        }
        .padding(StillwaterSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: StillwaterRadius.medium)
                .fill(isSelected ? feeling.color.opacity(0.15) : StillwaterColors.bgTertiary)
        )
        .overlay(
            RoundedRectangle(cornerRadius: StillwaterRadius.medium)
                .strokeBorder(isSelected ? feeling.color : .clear, lineWidth: 2)
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        FeelingSelector(
            selected: .constant(.calm),
            options: Feeling.postSessionFeelings,
            style: .horizontal
        )

        FeelingSelector(
            selected: .constant(.worried),
            options: Feeling.toolkitFeelings,
            style: .grid
        )
    }
    .padding()
}
