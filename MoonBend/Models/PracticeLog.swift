import SwiftData
import Foundation

/// Registra um dia em que a usuária concluiu ao menos uma prática completa.
/// `day` é sempre normalizado para o início do dia (00:00), o que torna
/// trivial comparar "esse dia tem prática?" no calendário.
@Model
final class PracticeLog {
    var id: UUID
    var day: Date

    init(day: Date) {
        self.id = UUID()
        self.day = Calendar.current.startOfDay(for: day)
    }
}
