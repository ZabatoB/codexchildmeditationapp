import SwiftUI

struct EditProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var childName: String = ""
    @State private var selectedAgeRange: ChildProfile.AgeRange = .middle

    var body: some View {
        List {
            Section {
                TextField("Child's Name", text: $childName)
                    .textInputAutocapitalization(.words)
            }

            Section("Age Range") {
                ForEach(ChildProfile.AgeRange.allCases, id: \.self) { range in
                    Button {
                        selectedAgeRange = range
                    } label: {
                        HStack {
                            Text(range.rawValue)
                                .foregroundStyle(StillwaterColors.textPrimary)

                            Spacer()

                            if selectedAgeRange == range {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(StillwaterColors.sage)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .disabled(childName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .onAppear {
            if let child = appState.currentChild {
                childName = child.name
                selectedAgeRange = child.ageRange
            }
        }
    }

    private func saveChanges() {
        guard var child = appState.currentChild else { return }

        child.name = childName.trimmingCharacters(in: .whitespaces)
        child.ageRange = selectedAgeRange

        appState.updateCurrentChild(child)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environment(AppState())
    }
}
