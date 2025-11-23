import SwiftData
import SwiftUI

@Model
final class CheckInItem {
    @Attribute(.unique) var trackerID: UUID
    var title: String
    var icon: String
    var color: CheckInColor
    var createdAt: Date

    init(
        title: String,
        icon: String,
        color: CheckInColor,
        createdAt: Date = .now
    ) {
        self.trackerID = UUID()
        self.title = title
        self.icon = icon
        self.color = color
        self.createdAt = createdAt
    }

    var tintColor: Color {
        color.color
    }
}

enum CheckInColor: String, CaseIterable, Identifiable, Codable {
    case ember
    case mint
    case tide
    case starlight
    case mist
    case blush
    case aura
    case grove

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ember:
            String(
                localized: "color.ember",
                defaultValue: "Ember"
            )
        case .mint:
            String(
                localized: "color.mint",
                defaultValue: "Mint"
            )
        case .tide:
            String(
                localized: "color.tide",
                defaultValue: "Tide"
            )
        case .starlight:
            String(
                localized: "color.starlight",
                defaultValue: "Starlight"
            )
        case .mist:
            String(
                localized: "color.mist",
                defaultValue: "Mist"
            )
        case .blush:
            String(
                localized: "color.blush",
                defaultValue: "Blush"
            )
        case .aura:
            String(
                localized: "color.aura",
                defaultValue: "Aura"
            )
        case .grove:
            String(
                localized: "color.grove",
                defaultValue: "Grove"
            )
        }
    }

    var color: Color {
        switch self {
        case .ember: .orange
        case .mint: .mint
        case .tide: .teal
        case .starlight: .indigo
        case .mist: Color.cyan.opacity(0.85)
        case .blush: .pink
        case .aura: .purple
        case .grove: Color.green.opacity(0.85)
        }
    }
}

extension CheckInItem {
    static var previewItems: [CheckInItem] {
        [
            CheckInItem(title: "Fat Burn", icon: "flame.fill", color: .ember),
            CheckInItem(title: "Walking", icon: "figure.walk", color: .mint),
            CheckInItem(title: "Reading", icon: "book.closed.fill", color: .tide),
            CheckInItem(title: "Lights Out", icon: "moon.stars.fill", color: .starlight)
        ]
    }

    static let iconSuggestions: [String] = [
        "flame.fill",
        "figure.walk",
        "figure.run",
        "fork.knife",
        "book.closed.fill",
        "moon.stars.fill",
        "drop.fill",
        "heart.fill",
        "sparkles",
        "leaf.fill",
        "cross.vial.fill",
        "pills",
        "brain.head.profile",
        "figure.mind.and.body",
        "sunrise.fill",
        "bed.double.fill",
        "hourglass.bottomhalf.fill"
    ]
}
