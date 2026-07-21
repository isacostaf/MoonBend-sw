import SwiftData
import Foundation

/// Uma sequência de ioga criada pela usuária: tem nome, foto de capa
/// e uma lista ordenada de itens (poses e/ou descansos).
@Model
final class YogaSequence {
    var id: UUID
    var name: String
    var imageData: Data?
    var createdAt: Date
    /// Descrição opcional da sequência — só aparece ao abrir os detalhes, nunca nos cards.
    var sequenceDescription: String?

    /// deleteRule: .cascade garante que, ao apagar a sequência, todos os
    /// SequenceItem relacionados também são apagados automaticamente.
    @Relationship(deleteRule: .cascade, inverse: \SequenceItem.sequence)
    var items: [SequenceItem] = []

    init(name: String, imageData: Data? = nil, sequenceDescription: String? = nil) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        self.createdAt = Date()
        self.sequenceDescription = sequenceDescription
    }

    /// Itens ordenados pela posição definida na criação da sequência
    var sortedItems: [SequenceItem] {
        items.sorted { $0.order < $1.order }
    }

    /// Soma da duração de todos os itens que têm tempo pré-determinado
    var totalDurationSeconds: Int {
        sortedItems.filter { $0.hasTimer }.reduce(0) { $0 + $1.durationSeconds }
    }

    /// Quantidade de poses (sem contar descansos/transições)
    var poseCount: Int {
        sortedItems.filter { $0.itemType == .pose }.count
    }
}
