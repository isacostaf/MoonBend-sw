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

    init(name: String, imageData: Data? = nil, isCustom: Bool = true) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}
