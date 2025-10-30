//
//  ContentView.swift
//  anchor
//
//  Created by Alex Yu on 2025/10/30.
//

import SwiftUI

struct ContentView: View {
    @State private var currentMonth: Date = Date()
    @State private var showAddSheet = false

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    CalendarSection(month: currentMonth, calendar: calendar)
                    CheckInSection(items: CheckInItem.sampleItems)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
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

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("打卡项目")
                .font(.title3.bold())
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(items) { item in
                    CheckInBadge(item: item)
                }
            }
        }
    }
}

private struct CheckInBadge: View {
    let item: CheckInItem

    var body: some View {
        ZStack {
            Circle()
                .fill(item.color.gradient).opacity(0.35)
            Group {
                switch item.icon {
                case .emoji(let value):
                    Text(value)
                case .symbol(let name):
                    Image(systemName: name)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }
            }
            .font(.system(size: 28))
        }
        .frame(width: 72, height: 72)
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
