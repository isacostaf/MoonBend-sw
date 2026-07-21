import SwiftUI

/// Os 3 passos do fluxo de criação/edição de sequência.
enum BuilderStep: Hashable {
    case selectPoses
    case configure
}

/// Ponto de entrada do fluxo de criação OU edição de sequência (3 passos,
/// tema claro): 1. Nome + foto + descrição opcional; 2. Selecionar poses
/// (repetíveis, com busca); 3. Configurar tempos, ordem e descansos.
///
/// Quando `existingSequence` é passado, o formulário é pré-preenchido e o
/// passo final ATUALIZA a sequência existente em vez de criar uma nova.
struct CreateSequenceFlowView: View {
    var existingSequence: YogaSequence?

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SequenceBuilderViewModel()
    @State private var path: [BuilderStep] = []

    private var isEditing: Bool { existingSequence != nil }

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
        .onAppear {
            if let existingSequence {
                viewModel.loadExisting(existingSequence)
            }
        }
    }

    // MARK: - Passo 1: nome, foto e descrição da sequência
    private var step1Content: some View {
        ScrollView {
            VStack(spacing: 28) {
                LightSectionHeader(title: isEditing ? "Editar sequência" : "Nova sequência", subtitle: "Passo 1 de 3")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)

                ImagePickerButton(imageData: $viewModel.imageData, size: 180)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome da sequência")
                        .font(.moonRounded(13, weight: .medium))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                    TextField("Ex: Fluxo matinal energizante", text: $viewModel.name)
                        .font(.moonRounded(16))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(MoonbendTheme.cardWhite))
                }
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Descrição")
                            .font(.moonRounded(13, weight: .medium))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                        Text("(opcional)")
                            .font(.moonRounded(12))
                            .foregroundStyle(MoonbendTheme.inkSecondary.opacity(0.7))
                    }
                    TextEditor(text: $viewModel.sequenceDescription)
                        .font(.moonRounded(15))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .scrollContentBackground(.hidden)
                        .frame(height: 100)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 16).fill(MoonbendTheme.cardWhite))
                }
                .padding(.horizontal, 24)

                LightPrimaryButton(
                    title: isEditing ? "Editar poses e continuar" : "Continuar",
                    isDisabled: viewModel.name.trimmingCharacters(in: .whitespaces).isEmpty
                ) {
                    path.append(.selectPoses)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .background(MoonbendTheme.creamBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(MoonbendTheme.creamBackground, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") { dismiss() }
            }
        }
    }
}
