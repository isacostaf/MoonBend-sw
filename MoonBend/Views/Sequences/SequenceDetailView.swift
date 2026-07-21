import SwiftUI
import SwiftData

/// Tela de detalhes de uma sequência (tema claro): foto de capa, descrição
/// (se houver), lista ordenada de poses/descansos, botão para iniciar a
/// prática, e opções para editar ou apagar a sequência.
struct SequenceDetailView: View {
    let sequence: YogaSequence
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var startPractice = false
    @State private var showEdit = false
    @State private var showDeleteConfirm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PoseImageView(imageData: sequence.imageData, cornerRadius: 28)
                    .frame(height: 220)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 6) {
                    Text(sequence.name)
                        .font(.moonRounded(24, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                    Text("\(sequence.poseCount) poses")
                        .font(.moonRounded(14))
                        .foregroundStyle(MoonbendTheme.inkSecondary)

                    if let description = sequence.sequenceDescription, !description.isEmpty {
                        Text(description)
                            .font(.moonRounded(15))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                            .padding(.top, 6)
                    }
                }
                .padding(.horizontal, 20)

                VStack(spacing: 12) {
                    ForEach(Array(sequence.sortedItems.enumerated()), id: \.element.id) { index, item in
                        LightItemRow {
                            HStack(spacing: 14) {
                                Text("\(index + 1)")
                                    .font(.moonRounded(13, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 26, height: 26)
                                    .background(Circle().fill(MoonbendTheme.pastelBlobGradient))

                                if item.itemType == .pose, let pose = item.pose {
                                    PoseImageView(imageData: pose.imageData, cornerRadius: 12)
                                        .frame(width: 44, height: 44)
                                    Text(pose.name)
                                        .font(.moonRounded(15, weight: .medium))
                                        .foregroundStyle(MoonbendTheme.inkPrimary)
                                } else {
                                    Image(systemName: "wind")
                                        .frame(width: 44, height: 44)
                                        .foregroundStyle(MoonbendTheme.inkSecondary)
                                    Text("Descanso / transição")
                                        .font(.moonRounded(15, weight: .medium))
                                        .foregroundStyle(MoonbendTheme.inkSecondary)
                                }

                                Spacer()

                                Text(item.hasTimer ? "\(item.durationSeconds)s" : "Livre")
                                    .font(.moonRounded(13, weight: .semibold))
                                    .foregroundStyle(MoonbendTheme.inkSecondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)

                LightPrimaryButton(title: "Praticar sequência", icon: "play.fill") {
                    startPractice = true
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                HStack(spacing: 14) {
                    Button {
                        showEdit = true
                    } label: {
                        Label("Editar", systemImage: "pencil")
                            .font(.moonRounded(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(MoonbendTheme.cardWhite)
                                    .shadow(color: MoonbendTheme.paleShadow, radius: 8, y: 3)
                            )
                    }

                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("Apagar", systemImage: "trash")
                            .font(.moonRounded(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 18).fill(Color(hex: "E4573D").opacity(0.9)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(MoonbendTheme.creamBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(MoonbendTheme.creamBackground, for: .navigationBar)
        .fullScreenCover(isPresented: $startPractice) {
            PracticeSequenceView(sequence: sequence)
        }
        .fullScreenCover(isPresented: $showEdit) {
            CreateSequenceFlowView(existingSequence: sequence)
        }
        .confirmationDialog(
            "Apagar esta sequência?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Apagar", role: .destructive) {
                modelContext.delete(sequence)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Essa sequência e todos os seus itens serão apagados permanentemente.")
        }
    }
}
