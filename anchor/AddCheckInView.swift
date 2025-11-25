import SwiftData
import SwiftUI

struct AddCheckInView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var nameFieldFocused: Bool

    @State private var name = ""
    @State private var category: CheckInCategory = .wellness
    @State private var icon = CheckInItem.iconSuggestions.first ?? "flame.fill"
    @State private var selectedColor: CheckInColor = .ember
    @State private var targetCount: Int = 1
    @State private var saveError: String?

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(
                    String(
                        localized: "addCheckIn.name",
                        defaultValue: "Name"
                    )
                ) {
                    TextField(
                        String(
                            localized: "addCheckIn.namePlaceholder",
                            defaultValue: "e.g. Hydrate"
                        ),
                        text: $name
                    )
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                    .focused($nameFieldFocused)
                }

                Section(
                    String(
                        localized: "addCheckIn.category",
                        defaultValue: "Category"
                    )
                ) {
                    Picker(
                        String(
                            localized: "addCheckIn.categoryPlaceholder",
                            defaultValue: "Choose a category"
                        ),
                        selection: $category
                    ) {
                        ForEach(CheckInCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(
                    String(
                        localized: "addCheckIn.icon",
                        defaultValue: "Symbol"
                    )
                ) {
                    TextField(
                        String(
                            localized: "addCheckIn.iconPlaceholder",
                            defaultValue: "SF Symbol name"
                        ),
                        text: $icon
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                    IconSuggestionsView(selectedIcon: $icon)
                        .padding(.vertical, 4)
                }

                Section(
                    String(
                        localized: "addCheckIn.color",
                        defaultValue: "Accent Color"
                    )
                ) {
                    ColorPickerGrid(selectedColor: $selectedColor)
                        .padding(.vertical, 4)
                }

                Section(
                    String(
                        localized: "addCheckIn.targetCount",
                        defaultValue: "Daily Target"
                    )
                ) {
                    Stepper(value: $targetCount, in: 1...20) {
                        Text("\(targetCount) times per day")
                    }
                }
            }
            .navigationTitle(
                String(
                    localized: "addCheckIn.title",
                    defaultValue: "Add Check-In"
                )
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(
                            String(
                                localized: "action.cancel",
                                defaultValue: "Cancel"
                            )
                        )
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveItem()
                    } label: {
                        Text(
                            String(
                                localized: "action.save",
                                defaultValue: "Save"
                            )
                        )
                    }
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            nameFieldFocused = true
        }
        .alert(
            String(
                localized: "addCheckIn.errorTitle",
                defaultValue: "Unable to Save"
            ),
            isPresented: Binding(
                get: { saveError != nil },
                set: { isPresented in
                    if !isPresented {
                        saveError = nil
                    }
                }
            )
        ) {
            Button(
                String(
                    localized: "action.ok",
                    defaultValue: "OK"
                ),
                role: .cancel
            ) {
                saveError = nil
            }
        } message: {
            Text(saveError ?? "")
        }
    }

    private func saveItem() {
        guard canSave else { return }

        let sanitizedIcon = icon.trimmingCharacters(in: .whitespacesAndNewlines)
        let item = CheckInItem(
            title: trimmedName,
            category: category,
            icon: sanitizedIcon.isEmpty ? "star" : sanitizedIcon,
            color: selectedColor,
            targetCount: targetCount
        )

        modelContext.insert(item)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            saveError = error.localizedDescription
        }
    }
}

private struct IconSuggestionsView: View {
    @Binding var selectedIcon: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(CheckInItem.iconSuggestions, id: \.self) { icon in
                    Button {
                        selectedIcon = icon
                    } label: {
                        Image(systemName: icon)
                            .font(.title3)
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.primary)
                            .background(
                                Circle()
                                    .fill(
                                        selectedIcon == icon
                                            ? Color.accentColor.opacity(0.2)
                                            : Color.clear
                                    )
                            )
                            .overlay {
                                if selectedIcon == icon {
                                    Circle()
                                        .stroke(Color.accentColor, lineWidth: 1.5)
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(icon)
                }
            }
            .padding(4)
        }
    }
}

private struct ColorPickerGrid: View {
    @Binding var selectedColor: CheckInColor

    private let columns = [GridItem(.adaptive(minimum: 72), spacing: 12)]
    private let selectedAccessibilityText = String(
        localized: "selection.selected",
        defaultValue: "Selected"
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(CheckInColor.allCases) { color in
                Button {
                    selectedColor = color
                } label: {
                    VStack(spacing: 8) {
                        Circle()
                            .fill(color.color)
                            .frame(width: 44, height: 44)
                            .overlay {
                                if selectedColor == color {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.white)
                                        .shadow(radius: 4, y: 1)
                                }
                            }

                        Text(color.displayName)
                            .font(.caption2)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                selectedColor == color
                                    ? Color.accentColor.opacity(0.1)
                                    : Color.clear
                            )
                    )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(color.displayName)
                .accessibilityValue(selectedColor == color ? selectedAccessibilityText : "")
            }
        }
    }
}
