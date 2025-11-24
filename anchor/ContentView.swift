//
//  ContentView.swift
//  anchor
//
//  Created by Alex Yu on 2025/10/30.
//

import AudioToolbox
import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var showAddSheet = false
    @Query(sort: [SortDescriptor(\CheckInItem.createdAt, order: .forward)])
    private var items: [CheckInItem]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        if items.isEmpty {
                            CheckInEmptyState {
                                showAddSheet = true
                            }
                        } else {
                            CheckInSection(items: items)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationTitle(
                String(
                    localized: "home.title",
                    defaultValue: "Today's Check-Ins"
                )
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddCheckInView()
                .presentationDetents([.large])
        }
    }
}

private struct CheckInSection: View {
    let items: [CheckInItem]
    @State private var completedIDs = Set<PersistentIdentifier>()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text(
//                String(
//                    localized: "section.checkIns",
//                    defaultValue: "Check-In Items"
//                )
//            )
//            .font(.title3.bold())
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    let identifier = item.id
                    CheckInCard(
                        item: item,
                        isCompleted: completedIDs.contains(identifier)
                    ) {
                        let currentlyCompleted = completedIDs.contains(identifier)
                        if currentlyCompleted {
                            completedIDs.remove(identifier)
                        } else {
                            completedIDs.insert(identifier)
                        }
                        AudioServicesPlaySystemSound(currentlyCompleted ? 1505 : 1504)
                    }
                }
            }
        }
    }
}

private struct CheckInCard: View {
    let item: CheckInItem
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {

        VStack(alignment: .trailing) {
            HStack {
                Image(systemName: item.icon)
                    .font(.title3)
                Spacer()
            }
            Spacer()
            Text(item.title)
                .font(.title3)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
        }
        .foregroundStyle(isCompleted ? Color(uiColor: .systemBackground) : .primary)
        .padding(16)
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture(perform: action)
        .glassEffect(
            .regular
            .interactive()
            .tint(.primary.opacity(isCompleted ? 1.0 : 0.0))
            ,
            in: .rect(cornerRadius: 34.0)
        )
    }
}


private struct CheckInEmptyState: View {
    let addAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(
                String(
                    localized: "emptyState.title",
                    defaultValue: "Create your first check-in"
                )
            )
            .font(.title3.bold())

            Text(
                String(
                    localized: "emptyState.description",
                    defaultValue: "Personalize this dashboard by adding the habits or routines you want to track."
                )
            )
            .font(.body)
            .foregroundStyle(.secondary)

            Button {
                addAction()
            } label: {
                Label(
                    String(
                        localized: "emptyState.addButton",
                        defaultValue: "Add check-in"
                    ),
                    systemImage: "plus"
                )
                .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
    }
}

private struct AddCheckInView: View {
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

#Preview("Light") {
    ContentView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

@MainActor
private let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: [CheckInItem.self, CheckInRecord.self],
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        CheckInItem.previewItems.forEach { container.mainContext.insert($0) }
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
