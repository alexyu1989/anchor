import SwiftUI

struct CheckInItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color

    static let sampleItems: [CheckInItem] = [
        CheckInItem(
            title: String(
                localized: "checkin.item.fatBurn",
                defaultValue: "Fat Burn"
            ),
            icon: "flame.fill",
            color: .orange
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.walking",
                defaultValue: "Walking"
            ),
            icon: "figure.walk",
            color: .mint
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.reading",
                defaultValue: "Reading"
            ),
            icon: "book.closed.fill",
            color: .teal
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.lightsOut",
                defaultValue: "Lights Out"
            ),
            icon: "moon.stars.fill",
            color: .indigo
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.hydrate",
                defaultValue: "Hydrate"
            ),
            icon: "drop.fill",
            color: .cyan.opacity(0.8)
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.heartFocus",
                defaultValue: "Heart Focus"
            ),
            icon: "heart.fill",
            color: .pink
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.meditation",
                defaultValue: "Meditation"
            ),
            icon: "sparkles",
            color: .purple
        ),
        CheckInItem(
            title: String(
                localized: "checkin.item.nature",
                defaultValue: "Nature Time"
            ),
            icon: "leaf.fill",
            color: .green.opacity(0.8)
        )
    ]
}
