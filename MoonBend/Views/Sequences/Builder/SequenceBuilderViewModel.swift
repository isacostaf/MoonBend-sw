import Foundation

/// Representa um item ainda em RASCUNHO durante a criação da sequência
/// (antes de ser salvo como SequenceItem no banco de dados).
/// É um struct (não @Model) porque só existe temporariamente na memória
/// enquanto a usuária está montando a sequência.
struct DraftSequenceItem: Identifiable, Equatable {
    let id = UUID()
    var type: SequenceItemType
    /// nil quando o item é um descanso/transição
    var pose: Pose?
    var hasTimer: Bool = false
    var durationSeconds: Int = 30

    static func == (lhs: DraftSequenceItem, rhs: DraftSequenceItem) -> Bool {
        lhs.id == rhs.id
    }
}

/// Guarda todo o estado do processo de criação de uma sequência
/// (nome, foto, lista de poses/descansos escolhidos) enquanto a usuária
/// navega pelos 3 passos. Só é persistido no SwiftData no passo final.
final class SequenceBuilderViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var imageData: Data?
    @Published var items: [DraftSequenceItem] = []

    /// Adiciona uma pose ao final da sequência (pode ser chamada
    /// várias vezes para a mesma pose — repetição é permitida).
    func addPose(_ pose: Pose) {
        items.append(DraftSequenceItem(type: .pose, pose: pose))
    }

    /// Insere um item de descanso/transição logo após o índice informado.
    func addRest(afterIndex index: Int) {
        let rest = DraftSequenceItem(type: .rest, pose: nil, hasTimer: true, durationSeconds: 15)
        items.insert(rest, at: index + 1)
    }

    func remove(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }

    /// A sequência só pode ser salva se tiver nome e ao menos uma pose
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && items.contains { $0.type == .pose }
    }
}
