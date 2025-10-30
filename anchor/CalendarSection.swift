import SwiftUI

struct CalendarSection: View {
    let month: Date
    let calendar: Calendar

    private struct DayCell: Identifiable {
        let id = UUID()
        let value: Int?
        let isToday: Bool
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(monthTitle)
                .font(.title2.bold())
                .foregroundStyle(.secondary)
            VStack(spacing: 12) {
                weekdayHeader
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 7), spacing: 8) {
                    ForEach(days) { day in
                        ZStack {
                            if day.isToday, let value = day.value {
                                Circle()
                                    .fill(Color(.label))
                                Text("\(value)")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.background)
                            } else if let value = day.value {
                                Text("\(value)")
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("")
                            }
                        }
                        .frame(width: 36, height: 36)
                    }
                }
            }
        }
    }

    private var monthTitle: String {
        CalendarSection.monthFormatter.string(from: month)
    }

    private var days: [DayCell] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let dayRange = calendar.range(of: .day, in: .month, for: month) else {
            return []
        }

        let firstDay = monthInterval.start
        let leadingSlots = leadingPadding(for: firstDay)

        var cells: [DayCell] = []
        cells.reserveCapacity(leadingSlots + dayRange.count)

        for _ in 0..<leadingSlots {
            cells.append(DayCell(value: nil, isToday: false))
        }

        for day in dayRange {
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDay) else {
                continue
            }
            cells.append(DayCell(value: day, isToday: calendar.isDateInToday(date)))
        }

        return cells
    }

    private func leadingPadding(for firstDay: Date) -> Int {
        let weekday = calendar.component(.weekday, from: firstDay)
        let adjustment = weekday - calendar.firstWeekday
        return (adjustment + 7) % 7
    }

    private var weekdayHeader: some View {
        let symbols = weekdaySymbols
        return HStack() {
            ForEach(symbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.body.bold())
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.primary)
            }
        }
    }

    private var weekdaySymbols: [String] {
        var symbols = calendar.veryShortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        if first > 0 {
            symbols = Array(symbols[first...]) + Array(symbols[..<first])
        }
        return symbols
    }

    private static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.dateFormat = "yyyy MMMM"
        return formatter
    }()
}

#Preview {
    CalendarSection(month: Date(), calendar: Calendar.current)
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
}
