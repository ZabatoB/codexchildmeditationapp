import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    @State private var showResetConfirmation = false
    @State private var showExportSheet = false

    var body: some View {
        List {
            Section("Profile") {
                SettingsRow(
                    title: "Child's Name",
                    value: appState.currentChild?.name ?? "Not set"
                ) {
                    appState.navigate(to: .editProfile)
                }

                SettingsRow(
                    title: "Age Range",
                    value: appState.currentChild?.ageRange.rawValue ?? "Not set"
                ) {
                    appState.navigate(to: .editProfile)
                }

                SettingsRow(
                    title: "Change Parent PIN",
                    value: nil
                ) {
                    appState.navigate(to: .changePIN)
                }
            }

            Section("Preferences") {
                Toggle(
                    "Bedtime Mode",
                    isOn: Binding(
                        get: { appState.settings.bedtimeModeEnabled },
                        set: { newValue in
                            var settings = appState.settings
                            settings.bedtimeModeEnabled = newValue
                            appState.storageService.saveSettings(settings)
                        }
                    )
                )
                .tint(StillwaterColors.sage)

                if appState.settings.bedtimeModeEnabled {
                    HStack {
                        Text("Bedtime Hour")
                        Spacer()
                        Text(bedtimeString)
                            .foregroundStyle(StillwaterColors.textSecondary)
                    }
                }
            }

            Section("Data") {
                Button {
                    showExportSheet = true
                } label: {
                    HStack {
                        Text("Export Practice Data")
                            .foregroundStyle(StillwaterColors.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(StillwaterColors.textTertiary)
                    }
                }

                Button {
                    showResetConfirmation = true
                } label: {
                    Text("Reset All Progress")
                        .foregroundStyle(StillwaterColors.error)
                }
            }

            Section("About") {
                SettingsRow(
                    title: "About Stillwater",
                    value: nil
                ) {
                    appState.navigate(to: .about)
                }

                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundStyle(StillwaterColors.textSecondary)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset All Progress?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                resetAllProgress()
            }
        } message: {
            Text("This will delete all practice history, learned skills, and garden progress. This cannot be undone.")
        }
        .sheet(isPresented: $showExportSheet) {
            ExportDataSheet()
        }
    }

    private var bedtimeString: String {
        let hour = appState.settings.bedtimeHour
        if hour < 12 {
            return "\(hour):00 AM"
        } else if hour == 12 {
            return "12:00 PM"
        } else {
            return "\(hour - 12):00 PM"
        }
    }

    private func resetAllProgress() {
        guard var child = appState.currentChild else { return }

        child.completedSessionIds = []
        child.learnedSkillIds = []
        child.gardenState = GardenState()

        appState.updateCurrentChild(child)
        appState.storageService.deleteSessions(forChild: child.id)
        appState.storageService.deleteToolkitUsage(forChild: child.id)
    }
}

struct SettingsRow: View {
    let title: String
    let value: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Spacer()

                if let value = value {
                    Text(value)
                        .foregroundStyle(StillwaterColors.textSecondary)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(StillwaterColors.textTertiary)
            }
        }
    }
}

struct ExportDataSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: StillwaterSpacing.lg) {
                Spacer()

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 60))
                    .foregroundStyle(StillwaterColors.sage)

                Text("Export Coming Soon")
                    .font(StillwaterFont.headlineMedium)
                    .foregroundStyle(StillwaterColors.textPrimary)

                Text("In a future update, you'll be able to export your child's practice history as a PDF or CSV file.")
                    .font(StillwaterFont.bodyMedium)
                    .foregroundStyle(StillwaterColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, StillwaterSpacing.xl)

                Spacer()
            }
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environment(AppState())
    }
}
