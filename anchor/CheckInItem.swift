import SwiftUI

struct CheckInItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color

    static let sampleItems: [CheckInItem] = [
        CheckInItem(title: "燃脂", icon: "flame.fill", color: .orange),
        CheckInItem(title: "步行", icon: "figure.walk", color: .mint),
        CheckInItem(title: "阅读", icon: "book.closed.fill", color: .teal),
        CheckInItem(title: "晚安", icon: "moon.stars.fill", color: .indigo),
        CheckInItem(title: "喝水", icon: "drop.fill", color: .cyan.opacity(0.8)),
        CheckInItem(title: "心动", icon: "heart.fill", color: .pink),
        CheckInItem(title: "冥想", icon: "sparkles", color: .purple),
        CheckInItem(title: "自然", icon: "leaf.fill", color: .green.opacity(0.8))
    ]
}
