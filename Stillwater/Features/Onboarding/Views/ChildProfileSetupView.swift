import SwiftUI

struct ChildProfileSetupView: View {
    @Environment(OnboardingViewModel.self) private var viewModel
    @FocusState private var isNameFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
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

            ScrollView {
                VStack(spacing: StillwaterSpacing.xl) {
                    Text("Let's personalize the experience")
                        .font(StillwaterFont.headlineLarge)
                        .foregroundStyle(StillwaterColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.top, StillwaterSpacing.xl)

                    VStack(alignment: .leading, spacing: StillwaterSpacing.xs) {
                        Text("Child's name")
                            .font(StillwaterFont.labelMedium)
                            .foregroundStyle(StillwaterColors.textSecondary)

                        TextField("", text: Binding(
                            get: { viewModel.childName },
                            set: { viewModel.childName = $0 }
                        ))
                        .font(StillwaterFont.bodyLarge)
                        .padding(StillwaterSpacing.md)
                        .background(StillwaterColors.bgTertiary)
                        .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
                        .focused($isNameFocused)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading, spacing: StillwaterSpacing.xs) {
                        Text("Age range")
                            .font(StillwaterFont.labelMedium)
                            .foregroundStyle(StillwaterColors.textSecondary)

                        AgeRangePicker(selection: Binding(
                            get: { viewModel.selectedAgeRange },
                            set: { viewModel.selectedAgeRange = $0 }
                        ))
                    }

                    VStack(alignment: .leading, spacing: StillwaterSpacing.sm) {
                        Text("Have they tried meditation before?")
                            .font(StillwaterFont.labelMedium)
                            .foregroundStyle(StillwaterColors.textSecondary)

                        ForEach(OnboardingViewModel.MeditationExperience.allCases) { experience in
                            ExperienceOption(
                                title: experience.rawValue,
                                isSelected: viewModel.meditationExperience == experience
                            ) {
                                viewModel.meditationExperience = experience
                            }
                        }
                    }

                    Spacer(minLength: StillwaterSpacing.xxl)
                }
                .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            }

            PrimaryButton("Continue") {
                isNameFocused = false
                viewModel.goToNextStep()
            }
            .disabled(!viewModel.isChildProfileValid)
            .opacity(viewModel.isChildProfileValid ? 1 : 0.5)
            .padding(.horizontal, StillwaterSpacing.screenHorizontal)
            .padding(.bottom, StillwaterSpacing.xl)
        }
    }
}

struct AgeRangePicker: View {
    @Binding var selection: ChildProfile.AgeRange

    var body: some View {
        HStack(spacing: StillwaterSpacing.xs) {
            ForEach(ChildProfile.AgeRange.allCases, id: \.self) { range in
                AgeRangeButton(
                    title: range.rawValue,
                    isSelected: selection == range
                ) {
                    withAnimation(StillwaterAnimation.quickEase) {
                        selection = range
                    }
                }
            }
        }
    }
}

struct AgeRangeButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(StillwaterFont.labelMedium)
                .foregroundStyle(isSelected ? .white : StillwaterColors.textPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, StillwaterSpacing.sm)
                .background(isSelected ? StillwaterColors.sage : StillwaterColors.bgTertiary)
                .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.small))
        }
    }
}

struct ExperienceOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .strokeBorder(isSelected ? StillwaterColors.sage : StillwaterColors.textTertiary, lineWidth: 2)
                    .background(Circle().fill(isSelected ? StillwaterColors.sage : .clear))
                    .frame(width: 22, height: 22)
                    .overlay {
                        if isSelected {
                            Circle()
                                .fill(.white)
                                .frame(width: 8, height: 8)
                        }
                    }

                Text(title)
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Spacer()
            }
            .padding(StillwaterSpacing.md)
            .background(StillwaterColors.bgTertiary)
            .clipShape(RoundedRectangle(cornerRadius: StillwaterRadius.medium))
        }
    }
}

#Preview {
    ChildProfileSetupView()
        .environment(OnboardingViewModel())
}
