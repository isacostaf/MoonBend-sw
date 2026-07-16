import SwiftUI
import SwiftData
import UIKit

@main
struct MoonbendApp: App {
    /// Container central do SwiftData — guarda Poses, Sequências e Itens de sequência
    /// em um banco de dados local no dispositivo (sem servidor, sem custo).
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Pose.self, YogaSequence.self, SequenceItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Não foi possível criar o ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(sharedModelContainer)
                .task {
                    seedInitialDataIfNeeded()
                }
        }
    }

    /// Cadastra as duas poses iniciais pedidas no briefing, apenas na primeira execução.
    /// IMPORTANTE: adicione imagens chamadas "pose_lagarto" e "pose_cachorro" no
    /// Assets.xcassets do projeto para que elas apareçam com foto real.
    /// Caso as imagens não existam nos Assets, a pose aparece com um ícone
    /// de fallback elegante (ver PoseImageView) — o app não quebra.
    @MainActor
    private func seedInitialDataIfNeeded() {
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<Pose>()
        let existingPoses = (try? context.fetch(descriptor)) ?? []
        guard existingPoses.isEmpty else { return }

        let lagarto = Pose(
            name: "Postura do Lagarto",
            imageData: UIImage(named: "pose_lagarto")?.pngData(),
            isCustom: false
        )
        let cachorro = Pose(
            name: "Cachorro Olhando para Baixo",
            imageData: UIImage(named: "pose_cachorro")?.pngData(),
            isCustom: false
        )

        context.insert(lagarto)
        context.insert(cachorro)
        try? context.save()
    }
}
