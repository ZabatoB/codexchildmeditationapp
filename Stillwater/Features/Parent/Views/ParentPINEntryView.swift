import SwiftUI

struct ParentPINEntryView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var enteredPIN: String = ""
    @State private var attempts: Int = 0
    @State private var showError: Bool = false
    @State private var shake: Bool = false

    private let maxAttempts = 5

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: StillwaterSpacing.xxs) {
                        Image(systemName: StillwaterIcon.back)
                        Text("Back")
                    }
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
                }
                Spacer()
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .padding(.top, StillwaterSpacing.md)

            Spacer()

            VStack(spacing: StillwaterSpacing.sm) {
                Text("Parent Area")
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("Enter your PIN to continue")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }

            Spacer()

            HStack(spacing: StillwaterSpacing.md) {
                ForEach(0..<4, id: \.self) { index in
                    Circle()
                        .fill(index < enteredPIN.count ? StillwaterColors.sage : StillwaterColors.bgTertiary)
                        .frame(width: 18, height: 18)
                        .overlay {
                            Circle()
                                .strokeBorder(StillwaterColors.sage.opacity(0.3), lineWidth: 2)
                        }
                }
            }
            .offset(x: shake ? -10 : 0)
            .animation(shake ? Animation.easeInOut(duration: 0.1).repeatCount(3) : nil, value: shake)

            if showError {
                Text("Incorrect PIN. \(maxAttempts - attempts) attempts remaining.")
                    .font(StillwaterFont.labelSmall)
                    .foregroundStyle(StillwaterColors.error)
                    .padding(.top, StillwaterSpacing.sm)
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

            Button {
                // TODO: Parent PIN recovery flow
            } label: {
                Text("Forgot PIN?")
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
            }
            .padding(.top, StillwaterSpacing.lg)
            .padding(.bottom, StillwaterSpacing.xxl)
        }
        .background(StillwaterColors.bgPrimary.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private func appendDigit(_ digit: String) {
        guard enteredPIN.count < 4 else { return }
        enteredPIN += digit

        if enteredPIN.count == 4 {
            verifyPIN()
        }
    }

    private func deleteDigit() {
        guard !enteredPIN.isEmpty else { return }
        enteredPIN.removeLast()
        showError = false
    }

    private func verifyPIN() {
        let storedPIN = appState.storageService.parentPIN ?? ""

        if enteredPIN == storedPIN {
            appState.navigate(to: .parentDashboard)
        } else {
            attempts += 1
            showError = true
            shake = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shake = false
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                enteredPIN = ""
            }

            if attempts >= maxAttempts {
                // TODO: lockout handling
            }
        }
    }
}

#Preview {
    ParentPINEntryView()
        .environment(AppState())
}
