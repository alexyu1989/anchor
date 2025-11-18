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
            .navigationTitle("今日打卡")
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
            HStack {
                Button("Run", systemImage: "figure.run") {
                    //
                }
                .tint(.orange)
                .buttonStyle(.glass)
                Button("Run", systemImage: "figure.run") {
                    //
                }
                .tint(.orange)
                .buttonStyle(.glassProminent)
                
            }
            Text("打卡项目")
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
        Button(action: action) {
            Label {
                Text(item.title)
                    .font(.headline)
            } icon: {
                icon
            }
        }
        .buttonStyle(isCompleted ? .glassProminent : .glass)
        .tint(item.color.opacity(isCompleted ? 1.0 : 0.1))
    }

    @ViewBuilder
    private var icon: some View {
        switch item.icon {
        case .emoji(let value):
            Text(value)
                .font(.system(size: 32))
                .foregroundStyle(.primary)
        case .symbol(let name):
            Image(systemName: name)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .font(.system(size: 30))
        }
    }
}


private struct AddPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "plus.circle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("添加打卡项目即将上线")
                .font(.headline)
            Text("这里之后会提供创建新打卡项目的界面。")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

private struct TextureBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GeometryReader { proxy in
            let gradientColors = colorScheme == .dark
                ? [Color(red: 0.06, green: 0.08, blue: 0.16), Color(red: 0.02, green: 0.03, blue: 0.1)]
                : [Color(red: 0.96, green: 0.93, blue: 0.98), Color(red: 0.74, green: 0.77, blue: 0.92)]

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
                    endRadius: max(proxy.size.width, proxy.size.height) * 0.7
                )
                RadialGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), .clear]),
                    center: .init(x: 0.8, y: 0.7),
                    startRadius: 20,
                    endRadius: max(proxy.size.width, proxy.size.height) * 0.6
                )
                Canvas { context, _ in
                    let step: CGFloat = 24
                    for x in stride(from: 0, to: proxy.size.width, by: step) {
                        for y in stride(from: 0, to: proxy.size.height, by: step) {
                            var rect = CGRect(x: x, y: y, width: step, height: step)
                            rect = rect.insetBy(dx: 1, dy: 1)
                            let noise = Double((x + y).truncatingRemainder(dividingBy: step * 3)) / (step * 3)
                            context.fill(Path(rect), with: .color(Color.white.opacity(0.02 + noise * 0.03)))
                        }
                    }
                }
                .blendMode(.screen)
                .opacity(0.45)
            }
            .ignoresSafeArea()
        }
    }
}
