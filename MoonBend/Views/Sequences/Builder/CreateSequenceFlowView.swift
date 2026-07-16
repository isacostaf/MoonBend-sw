import SwiftUI

/// Os 3 passos do fluxo de criação de sequência.
enum BuilderStep: Hashable {
    case selectPoses
    case configure
}

/// Ponto de entrada do fluxo de criação de sequência (3 passos, conforme pedido):
/// 1. Nome + foto
/// 2. Selecionar poses (repetíveis)
/// 3. Configurar tempos, ordem e descansos/transições
///
/// Usa um NavigationStack PRÓPRIO com `path` controlado manualmente.
/// Isso é o que permite que, ao concluir o passo 3, um único `dismiss()`
/// feche TODO o fluxo de uma vez (em vez de voltar passo a passo).
struct CreateSequenceFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SequenceBuilderViewModel()
    @State private var path: [BuilderStep] = []

    var body: some View {
        NavigationStack(path: $path) {
            step1Content
                .navigationDestination(for: BuilderStep.self) { step in
                    switch step {
                    case .selectPoses:
                        SelectPosesContent(viewModel: viewModel) {
                            path.append(.configure)
                        }
                    case .configure:
                        ConfigureSequenceContent(viewModel: viewModel) {
                            dismiss() // fecha o fluxo inteiro após salvar
                        }
                    }
                }
        }
    }

    // MARK: - Passo 1: nome e foto da sequência
    private var step1Content: some View {
        VStack(spacing: 28) {
            SectionHeader(title: "Nova sequência", subtitle: "Passo 1 de 3")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

            ImagePickerButton(imageData: $viewModel.imageData, size: 180)

            VStack(alignment: .leading, spacing: 8) {
                Text("Nome da sequência")
                    .font(.moonRounded(13, weight: .medium))
                    .foregroundStyle(MoonbendTheme.softGray)
                TextField("Ex: Fluxo matinal energizante", text: $viewModel.name)
                    .font(.moonRounded(16))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.08)))
            }
            .padding(.horizontal, 24)

            Spacer()

            PrimaryButton(
                title: "Continuar",
                isDisabled: viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty
            ) {
                path.append(.selectPoses)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .padding(.top, 20)
        .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
        }
    }
}
