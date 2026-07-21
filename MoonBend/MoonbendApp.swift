import SwiftUI
import SwiftData
import UIKit

@main
struct MoonbendApp: App {
    /// Container central do SwiftData — guarda Poses, Sequências e Itens de sequência
    /// em um banco de dados local no dispositivo (sem servidor, sem custo).
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Pose.self, YogaSequence.self, SequenceItem.self, PracticeLog.self])
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
                    seedInitialSequencesIfNeeded()
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

        let pinca = Pose(
            name: "Pose da Pinça",
            imageData: UIImage(named: "pose_pinca")?.pngData(),
            isCustom: false
        )
        
        let pinca_aberta = Pose(
            name: "Pose da Pinça Aberta",
            imageData: UIImage(named: "pose_pinca_aberta")?.pngData(),
            isCustom: false
        )
        
        let pinca_unilateral_direita = Pose(
            name: "Pose da Pinça Unilateral Direita",
            imageData: UIImage(named: "pose_pinca_unilateral")?.pngData(),
            isCustom: false
        )
        
        let pinca_unilateral_esquerda = Pose(
            name: "Pose da Pinça Unilateral Esquerda",
            imageData: UIImage(named: "pose_pinca_unilateral")?.pngData(),
            isCustom: false
        )
        
        let pombo_direita = Pose(
            name: "Pose do Pombo Direita",
            imageData: UIImage(named: "pose_pombo")?.pngData(),
            isCustom: false
        )
        
        let pombo_esquerda = Pose(
            name: "Pose do Pombo Esquerda",
            imageData: UIImage(named: "pose_pombo")?.pngData(),
            isCustom: false
        )
        
        let lua_crescente_direita = Pose(
            name: "Pose da Lua Crescente Direita",
            imageData: UIImage(named: "pose_lua_crescente")?.pngData(),
            isCustom: false
        )
        
        let lua_crescente_esquerda = Pose(
            name: "Pose da Lua Crescente Esquerda",
            imageData: UIImage(named: "pose_lua_crescente")?.pngData(),
            isCustom: false
        )
        
        let alongamento_posterior_deitado_direita = Pose(
            name: "Alongamento Posterior Deitado Direita",
            imageData: UIImage(named: "pose_alongamento_posterior_deitado")?.pngData(),
            isCustom: false
        )
        
        let alongamento_posterior_deitado_esquerda = Pose(
            name: "Alongamento Posterior Deitado Esquerda",
            imageData: UIImage(named: "pose_alongamento_posterior_deitado")?.pngData(),
            isCustom: false
        )
        
        let pinca_aberta_lateral_direita = Pose(
            name: "Pinça Aberta Lateral Direita",
            imageData: UIImage(named: "pose_pinca_aberta_lateral")?.pngData(),
            isCustom: false
        )
        
        let pinca_aberta_lateral_esquerda = Pose(
            name: "Pinça Aberta Lateral Esquerda",
            imageData: UIImage(named: "pose_pinca_aberta_lateral")?.pngData(),
            isCustom: false
        )
        
        let pinca_aberta_bracos_tras = Pose(
            name: "Pose da Pinça Aberta com Braços para trás",
            imageData: UIImage(named: "pose_pinca_aberta_bracos_tras")?.pngData(),
            isCustom: false
        )
        
        let sapo = Pose(
            name: "Pose do Sapo",
            imageData: UIImage(named: "pose_sapo")?.pngData(),
            isCustom: false
        )
        
        let sapo_direita = Pose(
            name: "Pose do 1/2 Sapo Direita",
            imageData: UIImage(named: "pose_12_sapo")?.pngData(),
            isCustom: false
        )
        
        let sapo_esquerda = Pose(
            name: "Pose do 1/2 Sapo Esquerda",
            imageData: UIImage(named: "pose_12_sapo")?.pngData(),
            isCustom: false
        )
        
        let sapo_direita_balanco = Pose(
            name: "Pose do 1/2 Sapo Direita Balanço",
            imageData: UIImage(named: "pose_12_sapo_balanco")?.pngData(),
            isCustom: false
        )
        
        let sapo_esquerda_balanco = Pose(
            name: "Pose do 1/2 Sapo Esquerda Balanço",
            imageData: UIImage(named: "pose_12_sapo_balanco")?.pngData(),
            isCustom: false
        )
        
        let borboleta = Pose(
            name: "Pose da Borboleta",
            imageData: UIImage(named: "pose_borboleta")?.pngData(),
            isCustom: false
        )
        
        let abertura_sapo = Pose(
            name: "Pose Abertura Sapo",
            imageData: UIImage(named: "pose_abertura_sapo")?.pngData(),
            isCustom: false
        )
        
        let meio_macaco_direita = Pose(
            name: "Pose do 1/2 Macaco Direta",
            imageData: UIImage(named: "pose_12_macaco")?.pngData(),
            isCustom: false
        )
        
        let meio_macaco_esquerda = Pose(
            name: "Pose do 1/2 Macaco Esquerda",
            imageData: UIImage(named: "pose_12_macaco")?.pngData(),
            isCustom: false
        )
        
        let lagarto_direita = Pose(
            name: "Pose do Lagarto Direita",
            imageData: UIImage(named: "pose_lagarto")?.pngData(),
            isCustom: false
        )
        
        let lagarto_esquerda = Pose(
            name: "Pose do Lagarto Esquerda",
            imageData: UIImage(named: "pose_lagarto")?.pngData(),
            isCustom: false
        )
        
        let lagarto_torcido_direita = Pose(
            name: "Pose do Lagarto Torcido Direita",
            imageData: UIImage(named: "pose_lagarto_torcido")?.pngData(),
            isCustom: false
        )
        
        let lagarto_torcido_esquerda = Pose(
            name: "Pose do Lagarto Torcido Esquerda",
            imageData: UIImage(named: "pose_lagarto_torcido")?.pngData(),
            isCustom: false
        )
        
        let espacate_direita = Pose(
            name: "Pose do Espacate Direita",
            imageData: UIImage(named: "pose_espacate")?.pngData(),
            isCustom: false
        )
        
        let espacate_esquerda = Pose(
            name: "Pose do Espacate Esquerda",
            imageData: UIImage(named: "pose_espacate")?.pngData(),
            isCustom: false
        )
        
        let espacate_vai_volta = Pose(
            name: "Pose do Espacate Vai e Volta",
            imageData: UIImage(named: "pose_espacate_vai_volta")?.pngData(),
            isCustom: false
        )
    
        
        

        context.insert(pinca)
        context.insert(pinca_aberta)

        context.insert(pinca_unilateral_direita)
        context.insert(pinca_unilateral_esquerda)

        context.insert(pombo_direita)
        context.insert(pombo_esquerda)

        context.insert(lua_crescente_direita)
        context.insert(lua_crescente_esquerda)

        context.insert(alongamento_posterior_deitado_direita)
        context.insert(alongamento_posterior_deitado_esquerda)

        context.insert(pinca_aberta_lateral_direita)
        context.insert(pinca_aberta_lateral_esquerda)

        context.insert(pinca_aberta_bracos_tras)

        context.insert(sapo)
        context.insert(sapo_direita)
        context.insert(sapo_esquerda)

        context.insert(sapo_direita_balanco)
        context.insert(sapo_esquerda_balanco)

        context.insert(borboleta)

        context.insert(abertura_sapo)

        context.insert(meio_macaco_direita)
        context.insert(meio_macaco_esquerda)

        context.insert(lagarto_direita)
        context.insert(lagarto_esquerda)

        context.insert(lagarto_torcido_direita)
        context.insert(lagarto_torcido_esquerda)

        context.insert(espacate_direita)
        context.insert(espacate_esquerda)

        context.insert(espacate_vai_volta)

        try? context.save()
    }
    
    @MainActor
    private func seedInitialSequencesIfNeeded() {

        let context = sharedModelContainer.mainContext

        // Evita criar duplicado
        let sequenceDescriptor = FetchDescriptor<YogaSequence>()
        let existingSequences = (try? context.fetch(sequenceDescriptor)) ?? []

        guard existingSequences.isEmpty else { return }


        // Busca todas as poses
        let poseDescriptor = FetchDescriptor<Pose>()
        let poses = (try? context.fetch(poseDescriptor)) ?? []


        func findPose(_ name: String) -> Pose? {
            poses.first {
                $0.name == name
            }
        }


        let sequence = YogaSequence(
            name: "Flexibilidade Profunda",
            imageData: UIImage(named: "sequencia1")?.pngData(),
            sequenceDescription: "Uma sequência completa para abertura de quadril, alongamento posterior e evolução da flexibilidade."
        )


        let poseNames = [

            "Pose da Pinça",

            "Pose da Pinça Aberta",

            "Pose da Pinça Unilateral Direita",
            "Pose da Pinça Unilateral Esquerda",

            "Pose do Pombo Direita",
            "Pose do Pombo Esquerda",

            "Alongamento Posterior Deitado Direita",
            "Alongamento Posterior Deitado Esquerda",

            "Pinça Aberta Lateral Direita",
            "Pinça Aberta Lateral Esquerda",

            "Pose da Pinça Aberta",

            "Pose do Sapo",

            "Pose do 1/2 Sapo Direita Balanço",
            "Pose do 1/2 Sapo Direita",

            "Pose do 1/2 Sapo Esquerda Balanço",
            "Pose do 1/2 Sapo Esquerda",

            "Pose Abertura Sapo",

            "Pose da Lua Crescente Direita",

            "Pose do 1/2 Macaco Direta",

            "Pose do Lagarto Direita",

            "Pose do Lagarto Torcido Direita",

            "Pose do Espacate Direita",

            "Pose da Lua Crescente Esquerda",

            "Pose do 1/2 Macaco Esquerda",

            "Pose do Lagarto Esquerda",

            "Pose do Lagarto Torcido Esquerda",

            "Pose do Espacate Esquerda",

            "Pose da Pinça Aberta",

            "Pose do Espacate Vai e Volta"
        ]


        for (index, name) in poseNames.enumerated() {

            guard let pose = findPose(name) else {
                continue
            }


            let item = SequenceItem(
                type: .pose,
                order: index,
                hasTimer: false,
                durationSeconds: 0,
                pose: pose
            )

            item.sequence = sequence

            context.insert(item)
        }


        context.insert(sequence)

        try? context.save()
    }
    
}
