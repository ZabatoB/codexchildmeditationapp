import SwiftUI

struct StillwaterShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let soft = StillwaterShadow(
        color: Color.black.opacity(0.06),
        radius: 8,
        x: 0,
        y: 4
    )

    static let medium = StillwaterShadow(
        color: Color.black.opacity(0.1),
        radius: 12,
        x: 0,
        y: 6
    )

    static let lifted = StillwaterShadow(
        color: Color.black.opacity(0.12),
        radius: 20,
        x: 0,
        y: 10
    )
}

// MARK: - View Extension
extension View {
    func stillwaterShadow(_ shadow: StillwaterShadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
