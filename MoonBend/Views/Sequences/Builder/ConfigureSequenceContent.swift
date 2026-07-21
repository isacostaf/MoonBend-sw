import SwiftUI
import SwiftData

/// Passo 3 (final) do fluxo de criação (tema claro): para cada pose
/// escolhida, a usuária decide se tem tempo pré-determinado e, se sim,
/// quantos segundos. Também pode reordenar (arrastar), apagar itens e
/// inserir descansos/transições entre quaisquer poses, quantas vezes quiser.
struct ConfigureSequenceContent: View {
    @ObservedObject var viewModel: SequenceBuilderViewModel
    let onFinish: () -> Void

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 0) {
            LightSectionHeader(title: "Configure os tempos", subtitle: "Passo 3 de 3")
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)

            List {
                ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                    itemRow(index: index, item: item)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onMove { source, destination in
                    viewModel.move(from: source, to: destination)
                }
                .onDelete { offsets in
                    viewModel.remove(at: offsets)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(MoonbendTheme.creamBackground)
            // Modo de edição sempre ativo: permite arrastar para reordenar
            // e deslizar para apagar, sem precisar de um botão "Editar" extra.
            .environment(\.editMode, .constant(.active))

            LightPrimaryButton(
                title: viewModel.existingSequence != nil ? "Salvar alterações" : "Concluir e salvar sequência",
                icon: "checkmark.circle.fill",
                isDisabled: !viewModel.isValid
            ) {
                saveSequence()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(MoonbendTheme.creamBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(MoonbendTheme.creamBackground, for: .navigationBar)
    }

    @ViewBuilder
    private func itemRow(index: Int, item: DraftSequenceItem) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(MoonbendTheme.inkSecondary)

                if item.type == .pose, let pose = item.pose {
                    PoseImageView(imageData: pose.imageData, cornerRadius: 12)
                        .frame(width: 44, height: 44)
                    Text(pose.name)
                        .font(.moonRounded(15, weight: .medium))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                } else {
                    Image(systemName: "wind")
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.white)
                        .background(Circle().fill(MoonbendTheme.lavender))
                    Text("Descanso / transição")
                        .font(.moonRounded(15, weight: .medium))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                }

                Spacer()

                Toggle("", isOn: bindingForTimer(index: index))
                    .labelsHidden()
                    .tint(MoonbendTheme.inkPrimary)
            }

            // Stepper de duração só aparece se o item tiver tempo pré-determinado ativado
            if viewModel.items[index].hasTimer {
                HStack {
                    Text("Duração:")
                        .font(.moonRounded(13))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                    Stepper(
                        "\(viewModel.items[index].durationSeconds) segundos",
                        value: bindingForDuration(index: index),
                        in: 5...300,
                        step: 5
                    )
                    .font(.moonRounded(13, weight: .medium))
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                }
            }

            Button {
                viewModel.addRest(afterIndex: index)
            } label: {
                Label("Adicionar descanso/transição depois", systemImage: "plus.circle")
                    .font(.moonRounded(12, weight: .medium))
                    .foregroundStyle(MoonbendTheme.inkSecondary)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 8, y: 3)
        )
    }

    // Bindings manuais para editar itens dentro de um array @Published por índice
    private func bindingForTimer(index: Int) -> Binding<Bool> {
        Binding(
            get: { viewModel.items[index].hasTimer },
            set: { viewModel.items[index].hasTimer = $0 }
        )
    }

    private func bindingForDuration(index: Int) -> Binding<Int> {
        Binding(
            get: { viewModel.items[index].durationSeconds },
            set: { viewModel.items[index].durationSeconds = $0 }
        )
    }

    /// Converte o rascunho (DraftSequenceItem) em modelos persistentes do
    /// SwiftData (YogaSequence + SequenceItem) e salva no banco local.
    /// Em modo de edição, atualiza a sequência existente em vez de criar uma nova.
    private func saveSequence() {
        let trimmedDescription = viewModel.sequenceDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDescription = trimmedDescription.isEmpty ? nil : trimmedDescription

        let sequence: YogaSequence
        if let existing = viewModel.existingSequence {
            sequence = existing
            sequence.name = viewModel.name.trimmingCharacters(in: .whitespaces)
            sequence.imageData = viewModel.imageData
            sequence.sequenceDescription = finalDescription
            // Remove os itens antigos para recriar na ordem/config atual
            for item in sequence.items {
                modelContext.delete(item)
            }
            sequence.items = []
        } else {
            sequence = YogaSequence(
                name: viewModel.name.trimmingCharacters(in: .whitespaces),
                imageData: viewModel.imageData,
                sequenceDescription: finalDescription
            )
            modelContext.insert(sequence)
        }

        for (index, draft) in viewModel.items.enumerated() {
            let sequenceItem = SequenceItem(
                type: draft.type,
                order: index,
                hasTimer: draft.hasTimer,
                durationSeconds: draft.durationSeconds,
                pose: draft.pose
            )
            sequenceItem.sequence = sequence
            modelContext.insert(sequenceItem)
        }

        try? modelContext.save()
        onFinish()
    }
}
