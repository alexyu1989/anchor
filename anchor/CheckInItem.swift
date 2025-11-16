import SwiftUI

struct CheckInItem: Identifiable {
    enum Icon {
        case emoji(String)
        case symbol(String)
    }

    let id = UUID()
    let title: String
    let icon: Icon
    let color: Color

    static let sampleItems: [CheckInItem] = [
        CheckInItem(title: "燃脂", icon: .symbol("flame.fill"), color: .orange),
        CheckInItem(title: "步行", icon: .symbol("figure.walk"), color: .mint),
        CheckInItem(title: "阅读", icon: .symbol("book.closed.fill"), color: .teal),
        CheckInItem(title: "晚安", icon: .symbol("moon.stars.fill"), color: .indigo),
        CheckInItem(title: "喝水", icon: .symbol("drop.fill"), color: .cyan.opacity(0.8)),
        CheckInItem(title: "心动", icon: .symbol("heart.fill"), color: .pink),
        CheckInItem(title: "冥想", icon: .symbol("sparkles"), color: .purple),
        CheckInItem(title: "自然", icon: .symbol("leaf.fill"), color: .green.opacity(0.8))
    ]
}
