import SwiftUI

struct ParentPINSetupView: View {
    @Environment(OnboardingViewModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    viewModel.resetPINEntry()
                    viewModel.goToPreviousStep()
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
                Text(viewModel.pinStep == .enter ? "Set a parent PIN" : "Confirm your PIN")
                    .font(StillwaterFont.headlineLarge)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text(viewModel.pinStep == .enter
                    ? "This keeps settings and data private."
                    : "Enter the same PIN again.")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)

            Spacer()

            PINDotsView(
                enteredCount: viewModel.pinStep == .enter
                    ? viewModel.enteredPIN.count
                    : viewModel.confirmPIN.count,
                hasError: viewModel.pinError != nil
            )

            if let error = viewModel.pinError {
                Text(error)
                    .font(StillwaterFont.labelMedium)
                    .foregroundStyle(StillwaterColors.error)
                    .padding(.top, StillwaterSpacing.sm)
            }

            Spacer()

            NumberPadView(
                onNumberTap: { digit in
                    viewModel.appendPINDigit(digit)
                    checkPINCompletion()
                },
                onDelete: {
                    viewModel.deletePINDigit()
                }
            )
            .padding(.horizontal, StillwaterSpacing.xl)
            .padding(.bottom, StillwaterSpacing.xxl)
        }
    }

    private func checkPINCompletion() {
        if viewModel.pinStep == .confirm && viewModel.confirmPIN.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if viewModel.isPINConfirmed {
                    viewModel.goToNextStep()
                } else {
                    viewModel.resetPINConfirmation()
                }
            }
        }
    }
}

struct PINDotsView: View {
    let enteredCount: Int
    let hasError: Bool
    let totalDots: Int = 4

    @State private var shake = false

    var body: some View {
        HStack(spacing: StillwaterSpacing.md) {
            ForEach(0..<totalDots, id: \.self) { index in
                Circle()
                    .fill(index < enteredCount ? StillwaterColors.sage : StillwaterColors.bgTertiary)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Circle()
                            .strokeBorder(StillwaterColors.sage.opacity(0.3), lineWidth: 2)
                    }
            }
        }
        .offset(x: shake ? -10 : 0)
        .onChange(of: hasError) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
                    shake = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    shake = false
                }
            }
        }
    }
}

#Preview {
    ParentPINSetupView()
        .environment(OnboardingViewModel())
}
