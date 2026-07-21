import Foundation

/// Calcula a sequência (streak) de dias consecutivos praticados.
enum StreakCalculator {
    /// Retorna quantos dias consecutivos a usuária já praticou, contando
    /// para trás a partir de hoje. Se hoje ainda não foi praticado, mas
    /// ontem foi, a sequência continua "viva" e conta a partir de ontem —
    /// só zera se um dia inteiro passar sem prática.
    static func currentStreak(logs: [PracticeLog], calendar: Calendar = .current) -> Int {
        guard !logs.isEmpty else { return 0 }

        let loggedDays = Set(logs.map { calendar.startOfDay(for: $0.day) })
        var cursor = calendar.startOfDay(for: Date())

        if !loggedDays.contains(cursor) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: cursor) else { return 0 }
            cursor = yesterday
        }

        var streak = 0
        while loggedDays.contains(cursor) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }
        return streak
    }

    /// Retorna a maior sequência de dias consecutivos já alcançada (recorde histórico).
    static func longestStreak(logs: [PracticeLog], calendar: Calendar = .current) -> Int {
        guard !logs.isEmpty else { return 0 }
        let loggedDays = Set(logs.map { calendar.startOfDay(for: $0.day) }).sorted()

        var longest = 0
        var current = 0
        var previousDay: Date?

        for day in loggedDays {
            if let previousDay, let expected = calendar.date(byAdding: .day, value: 1, to: previousDay), calendar.isDate(expected, inSameDayAs: day) {
                current += 1
            } else {
                current = 1
            }
            longest = max(longest, current)
            previousDay = day
        }
        return longest
    }
}
