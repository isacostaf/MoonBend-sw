import SwiftData
import Foundation

/// Um item de sequência pode ser uma POSE ou um DESCANSO/TRANSIÇÃO.
/// Isso permite inserir descanso entre quaisquer poses, quantas vezes quiser.
enum SequenceItemType: String, Codable {
    case pose
    case rest
}

/// Cada posição dentro de uma sequência de ioga.
/// Guardamos "typeRaw" (String) em vez do enum diretamente porque o SwiftData
/// persiste tipos simples com mais previsibilidade; expomos o enum via `itemType`.
@Model
final class SequenceItem {
    var id: UUID
    var typeRaw: String
    /// Posição do item dentro da sequência (0, 1, 2...) — define a ordem de execução
    var order: Int
    /// Se true, o item tem tempo pré-determinado (cronômetro automático)
    var hasTimer: Bool
    /// Duração em segundos (só é usada quando hasTimer == true)
    var durationSeconds: Int

    /// Referência à pose (nil quando o item é um descanso/transição)
    var pose: Pose?

    /// Relacionamento inverso — permite apagar todos os itens quando a sequência é apagada
    var sequence: YogaSequence?

    init(type: SequenceItemType, order: Int, hasTimer: Bool = false, durationSeconds: Int = 30, pose: Pose? = nil) {
        self.id = UUID()
        self.typeRaw = type.rawValue
        self.order = order
        self.hasTimer = hasTimer
        self.durationSeconds = durationSeconds
        self.pose = pose
    }

    var itemType: SequenceItemType {
        SequenceItemType(rawValue: typeRaw) ?? .pose
    }
}
