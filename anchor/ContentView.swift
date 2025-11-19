//
//  ContentView.swift
//  anchor
//
//  Created by Alex Yu on 2025/10/30.
//

import AudioToolbox
import SwiftUI

struct ContentView: View {
    @State private var currentMonth: Date = Date()
    @State private var showAddSheet = false

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                TextureBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // CalendarSection currently hidden while the card-based check-in layout is the focus.
                        CheckInSection(items: CheckInItem.sampleItems)
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
            AddPlaceholderView()
                .presentationDetents([.medium])
        }
    }
}

private struct CheckInSection: View {
    let items: [CheckInItem]
    @State private var completedIDs = Set<UUID>()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(
                String(
                    localized: "section.checkIns",
                    defaultValue: "Check-In Items"
                )
            )
            .font(.title3.bold())
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    CheckInCard(
                        item: item,
                        isCompleted: completedIDs.contains(item.id)
                    ) {
                        let currentlyCompleted = completedIDs.contains(item.id)
                        if currentlyCompleted {
                            completedIDs.remove(item.id)
                        } else {
                            completedIDs.insert(item.id)
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

        VStack {
            HStack {
                Image(systemName: item.icon)
                Spacer()
            }
            Spacer()
            HStack {
                Text(item.title)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.primary)
                Spacer()
            }
        }
        .padding(16)
        .aspectRatio(1, contentMode: .fit)
        .contentShape(
            RoundedRectangle(cornerRadius: 34.0, style: .continuous)
        )
        .onTapGesture(perform: action)
        .glassEffect(
            .clear.interactive().tint(item.color.opacity(isCompleted ? 1.0 : 0.1)),
            in: .rect(cornerRadius: 34.0)
        )
    }
}


private struct AddPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(
                String(
                    localized: "placeholder.addComingSoon",
                    defaultValue: "Add check-in items coming soon"
                )
            )
                .font(.headline)
            Text(
                String(
                    localized: "placeholder.addDescription",
                    defaultValue: "You'll be able to create new check-ins here later."
                )
            )
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}

private struct TextureBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let maxDimension = max(size.width, size.height)
            let gradientColors = colorScheme == .dark
                ? [Color(red: 0.06, green: 0.08, blue: 0.16), Color(red: 0.02, green: 0.03, blue: 0.1)]
                : [Color(red: 0.95, green: 0.95, blue: 0.99), Color(red: 0.78, green: 0.81, blue: 0.92)]
            let noiseBaseColor = colorScheme == .dark ? Color.white : Color.black
            let noiseBlendMode: BlendMode = colorScheme == .dark ? .screen : .multiply
            let noiseOpacity: Double = colorScheme == .dark ? 0.45 : 0.35

            ZStack {
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                RadialGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.25), .clear]),
                    center: .init(x: 0.2, y: 0.15),
                    startRadius: 40,
                    endRadius: maxDimension * 0.8
                )
                RadialGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.25), .clear]),
                    center: .init(x: 0.85, y: 0.65),
                    startRadius: 30,
                    endRadius: maxDimension * 0.7
                )
                Canvas { context, size in
                    let step: CGFloat = 22
                    for x in stride(from: -step, through: size.width + step, by: step) {
                        for y in stride(from: -step, through: size.height + step, by: step) {
                            var rect = CGRect(x: x, y: y, width: step, height: step)
                            rect = rect.insetBy(dx: 1, dy: 1)
                            let seed = sin((Double(x) * 12.9898 + Double(y) * 78.233) * 43758.5453)
                            let noise = seed - floor(seed)
                            context.fill(
                                Path(rect),
                                with: .color(
                                    noiseBaseColor.opacity(
                                        (colorScheme == .dark ? 0.02 : 0.04) + noise * (colorScheme == .dark ? 0.03 : 0.05)
                                    )
                                )
                            )
                        }
                    }
                }
                .blendMode(noiseBlendMode)
                .opacity(noiseOpacity)
            }
            .frame(width: size.width * 2, height: size.height * 2)
            .ignoresSafeArea()
        }
    }
}
