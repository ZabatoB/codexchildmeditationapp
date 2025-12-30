import SwiftUI

struct ChangePINView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    enum Step {
        case enterCurrent
        case enterNew
        case confirmNew
    }

    @State private var step: Step = .enterCurrent
    @State private var currentPIN: String = ""
    @State private var newPIN: String = ""
    @State private var confirmPIN: String = ""
    @State private var error: String?
    @State private var shake: Bool = false

    var body: some View {
        VStack(spacing: StillwaterSpacing.xl) {
            Spacer()

            Text(titleText)
                .font(StillwaterFont.headlineMedium)
                .foregroundStyle(StillwaterColors.textPrimary)

            HStack(spacing: StillwaterSpacing.md) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < currentPINLength ? StillwaterColors.sage : StillwaterColors.bgTertiary)
                        .frame(width: 18, height: 18)
                        .overlay {
                            Circle()
                                .strokeBorder(StillwaterColors.sage.opacity(0.3), lineWidth: 2)
                        }
                }
            }
            .offset(x: shake ? -10 : 0)

            if let error = error {
                Text(error)
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.error)
            }

            Spacer()

            NumberPadView(
                onNumberTap: { digit in
                    appendDigit(digit)
                },
                onDelete: {
                    deleteDigit()
                }
            )
            .padding(.horizontal, StillwaterSpacing.xl)
            .padding(.bottom, StillwaterSpacing.xxl)
        }
        .background(StillwaterColors.bgPrimary.ignoresSafeArea())
        .navigationTitle("Change PIN")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var titleText: String {
        switch step {
        case .enterCurrent: return "Enter current PIN"
        case .enterNew: return "Enter new PIN"
        case .confirmNew: return "Confirm new PIN"
        }
    }

    private var currentPINLength: Int {
        switch step {
        case .enterCurrent: return currentPIN.count
        case .enterNew: return newPIN.count
        case .confirmNew: return confirmPIN.count
        }
    }

    private func appendDigit(_ digit: String) {
        error = nil

        switch step {
        case .enterCurrent:
            guard currentPIN.count < 4 else { return }
            currentPIN += digit
            if currentPIN.count == 4 {
                verifyCurrent()
            }

        case .enterNew:
            guard newPIN.count < 4 else { return }
            newPIN += digit
            if newPIN.count == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    step = .confirmNew
                }
            }

        case .confirmNew:
            guard confirmPIN.count < 4 else { return }
            confirmPIN += digit
            if confirmPIN.count == 4 {
                verifyNewPIN()
            }
        }
    }

    private func deleteDigit() {
        error = nil

        switch step {
        case .enterCurrent:
            if !currentPIN.isEmpty { currentPIN.removeLast() }
        case .enterNew:
            if !newPIN.isEmpty { newPIN.removeLast() }
        case .confirmNew:
            if !confirmPIN.isEmpty { confirmPIN.removeLast() }
        }
    }

    private func verifyCurrent() {
        let storedPIN = appState.storageService.parentPIN ?? ""

        if currentPIN == storedPIN {
            step = .enterNew
        } else {
            error = "Incorrect PIN"
            triggerShake()
            currentPIN = ""
        }
    }

    private func verifyNewPIN() {
        if newPIN == confirmPIN {
            appState.storageService.parentPIN = newPIN
            dismiss()
        } else {
            error = "PINs don't match"
            triggerShake()
            confirmPIN = ""
        }
    }

    private func triggerShake() {
        shake = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            shake = false
        }
    }
}

#Preview {
    NavigationStack {
        ChangePINView()
            .environment(AppState())
    }
}
