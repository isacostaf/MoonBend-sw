import SwiftData
import Foundation

/// Representa uma postura de ioga: pode ser uma pose já cadastrada no sistema
/// (isCustom = false) ou criada pela própria usuária (isCustom = true).
@Model
final class Pose {
    var id: UUID
    var name: String
    /// Foto da pose guardada como Data (JPEG/PNG) — evita gerenciar arquivos soltos no disco
    var imageData: Data?
    var isCustom: Bool
    var createdAt: Date
    /// Descrição opcional da pose — só aparece ao abrir os detalhes, nunca nos cards.
    var poseDescription: String?
    /// Tags criadas livremente pela usuária para organizar/filtrar poses.
    /// Uma pose pode ter quantas tags quiser.
    var tags: [String] = []

    init(name: String, imageData: Data? = nil, isCustom: Bool = true, poseDescription: String? = nil, tags: [String] = []) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        self.isCustom = isCustom
        self.createdAt = Date()
        self.poseDescription = poseDescription
        self.tags = tags
    }
}
