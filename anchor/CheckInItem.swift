import SwiftUI

struct CheckInItem: Identifiable {
    enum Icon {
        case emoji(String)
        case symbol(String)
    }

    let id = UUID()
    let icon: Icon
    let color: Color

    static let sampleItems: [CheckInItem] = [
        CheckInItem(icon: .emoji("🔥"), color: .orange),
        CheckInItem(icon: .symbol("figure.walk"), color: .mint),
        CheckInItem(icon: .emoji("📚"), color: .teal),
        CheckInItem(icon: .symbol("moon.stars.fill"), color: .indigo),
        CheckInItem(icon: .emoji("💧"), color: .cyan.opacity(0.8)),
        CheckInItem(icon: .symbol("heart.fill"), color: .pink),
        CheckInItem(icon: .emoji("🧘🏻"), color: .purple),
        CheckInItem(icon: .symbol("leaf.fill"), color: .green.opacity(0.8))
    ]
}
