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
    @Environment(\.modelContext) private var modelContext
    @State private var showAddSheet = false
    @State private var persistenceError: String?
    @Query(sort: [SortDescriptor(\CheckInItem.createdAt, order: .forward)])
    private var items: [CheckInItem]
    @Query private var todayRecords: [CheckInRecord]
    private let today: Date

    init() {
        let normalizedToday = CheckInItem.normalizedDay(for: .now)
        self.today = normalizedToday
        _todayRecords = Query(
            filter: #Predicate { record in
                record.date == normalizedToday
            }
        )
    }

    private var completionLookup: [PersistentIdentifier: CheckInRecord] {
        var mapping: [PersistentIdentifier: CheckInRecord] = [:]
        for record in todayRecords {
            guard let identifier = record.item?.persistentModelID else { continue }
            mapping[identifier] = record
        }
        return mapping
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                GridBackground(
                    spacing: 18,
                    lineWidth: 1,
                    lineColor: .primary.opacity(0.03)
                )
                .allowsHitTesting(false)
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        if items.isEmpty {
                            CheckInEmptyState {
                                showAddSheet = true
                            }
                        } else {
                            CheckInSection(
                                items: items,
                                completedRecords: completionLookup,
                                toggleAction: toggleCheckIn
                            )
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
                .environment(\.modelContext, modelContext)
                .presentationDetents([.large])
        }
        .alert(
            String(
                localized: "error.storageFailure",
                defaultValue: "Unable to update check-in"
            ),
            isPresented: Binding(
                get: { persistenceError != nil },
                set: { isPresented in
                    if !isPresented {
                        persistenceError = nil
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
                persistenceError = nil
            }
        } message: {
            Text(persistenceError ?? "")
        }
    }

    private func toggleCheckIn(for item: CheckInItem) {
        let itemID = item.persistentModelID
        let existingRecord = completionLookup[itemID]

        if let record = existingRecord {
            if record.isCompleted {
                modelContext.delete(record)
            } else {
                record.count = item.targetCount
                record.item = item
            }
        } else {
            let newRecord = CheckInRecord(
                date: today,
                count: item.targetCount,
                item: item
            )
            modelContext.insert(newRecord)
        }

        do {
            try modelContext.save()
        } catch {
            persistenceError = error.localizedDescription
        }
    }
}

private struct CheckInSection: View {
    let items: [CheckInItem]
    let completedRecords: [PersistentIdentifier: CheckInRecord]
    let toggleAction: (CheckInItem) -> Void

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
                    let record = completedRecords[identifier]
                    let wasCompleted = record?.isCompleted ?? false
                    CheckInCard(
                        item: item,
                        isCompleted: record?.isCompleted ?? false
                    ) {
                        toggleAction(item)
                        AudioServicesPlaySystemSound(wasCompleted ? 1505 : 1504)
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
                    .font(.title2)
                Spacer()
            }
            Spacer()
            Text(item.title)
                .font(.headline)
                .fontWeight(.bold)
                .multilineTextAlignment(.trailing)
                .lineLimit(3)
                .minimumScaleFactor(0.6)
        }
        .foregroundStyle(isCompleted ? Color(uiColor: .systemBackground) : .primary)
        .padding(16)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .contentShape(RoundedRectangle(cornerRadius: 34.0, style: .continuous))
        .onTapGesture(perform: action)
        .glassEffect(
            .regular
            .interactive()
            .tint(.primary.opacity(isCompleted ? 1.0: 0.0))
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
            for: CheckInItem.self,
            CheckInRecord.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        CheckInItem.previewItems.forEach { container.mainContext.insert($0) }
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()
