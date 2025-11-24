import SwiftData
import SwiftUI

@Model
final class CheckInItem {
    @Attribute(.unique) var trackerID: UUID
    var title: String
    var category: CheckInCategory
    var icon: String
    var color: CheckInColor
    var targetCount: Int
    var createdAt: Date
    @Relationship(deleteRule: .cascade, inverse: \CheckInRecord.item)
    var records: [CheckInRecord]

    init(
        title: String,
        category: CheckInCategory = .wellness,
        icon: String,
        color: CheckInColor,
        targetCount: Int = 1,
        createdAt: Date = .now
    ) {
        self.trackerID = UUID()
        self.title = title
        self.category = category
        self.icon = icon
        self.color = color
        self.targetCount = max(1, targetCount)
        self.createdAt = createdAt
        self.records = []
    }

    var tintColor: Color {
        color.color
    }

    static func normalizedDay(for date: Date) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(secondsFromGMT: 0) ?? .current
        return calendar.startOfDay(for: date)
    }
}

@Model
final class CheckInRecord {
    var date: Date
    var count: Int
    var item: CheckInItem?

    init(
        date: Date = .now,
        count: Int = 0,
        item: CheckInItem? = nil
    ) {
        self.date = CheckInItem.normalizedDay(for: date)
        self.count = max(0, count)
        self.item = item
    }

    var isCompleted: Bool {
        guard let item else { return false }
        return count >= item.targetCount
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

enum CheckInCategory: String, CaseIterable, Identifiable, Codable {
    case wellness
    case fitness
    case nutrition
    case sleep
    case mindfulness
    case productivity
    case learning
    case social
    case chores
    case finance

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wellness:
            String(
                localized: "category.wellness",
                defaultValue: "Wellness"
            )
        case .fitness:
            String(
                localized: "category.fitness",
                defaultValue: "Fitness"
            )
        case .nutrition:
            String(
                localized: "category.nutrition",
                defaultValue: "Nutrition"
            )
        case .sleep:
            String(
                localized: "category.sleep",
                defaultValue: "Sleep"
            )
        case .mindfulness:
            String(
                localized: "category.mindfulness",
                defaultValue: "Mindfulness"
            )
        case .productivity:
            String(
                localized: "category.productivity",
                defaultValue: "Productivity"
            )
        case .learning:
            String(
                localized: "category.learning",
                defaultValue: "Learning"
            )
        case .social:
            String(
                localized: "category.social",
                defaultValue: "Social"
            )
        case .chores:
            String(
                localized: "category.chores",
                defaultValue: "Chores"
            )
        case .finance:
            String(
                localized: "category.finance",
                defaultValue: "Finance"
            )
        }
    }
}

extension CheckInItem {
    static var previewItems: [CheckInItem] {
        [
            CheckInItem(title: "Fat Burn", category: .fitness, icon: "flame.fill", color: .ember),
            CheckInItem(title: "Walking", category: .fitness, icon: "figure.walk", color: .mint),
            CheckInItem(title: "Reading", category: .learning, icon: "book.closed.fill", color: .tide),
            CheckInItem(title: "Lights Out", category: .sleep, icon: "moon.stars.fill", color: .starlight)
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
