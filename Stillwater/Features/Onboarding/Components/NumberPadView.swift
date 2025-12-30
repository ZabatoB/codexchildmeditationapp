import SwiftUI
import UIKit

struct NumberPadView: View {
    var onNumberTap: (String) -> Void
    var onDelete: () -> Void

    private let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: StillwaterSpacing.sm) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: StillwaterSpacing.sm) {
                    ForEach(row, id: \.self) { key in
                        NumberPadKey(key: key) {
                            if key == "⌫" {
                                onDelete()
                            } else if !key.isEmpty {
                                onNumberTap(key)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct NumberPadKey: View {
    let key: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            if !key.isEmpty {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                action()
            }
        }) {
            Group {
                if key.isEmpty {
                    Color.clear
                } else {
                    Text(key)
                        .font(StillwaterFont.displaySmall)
                        .foregroundStyle(key == "⌫" ? StillwaterColors.textSecondary : StillwaterColors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(key == "⌫" ? .clear : StillwaterColors.bgTertiary)
                        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
        }
        .disabled(key.isEmpty)
    }
}

#Preview {
    NumberPadView(
        onNumberTap: { print($0) },
        onDelete: { print("delete") }
    )
    .padding()
}
