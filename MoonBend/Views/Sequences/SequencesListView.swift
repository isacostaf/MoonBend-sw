import SwiftUI
import SwiftData
import UIKit

/// Aba "Sequências" — mesmo padrão visual da Home: fundo creme, barra de
/// pesquisa branca com sombra, grade de cards brancos.
struct SequencesListView: View {
    @Query(sort: \YogaSequence.createdAt, order: .reverse) private var sequences: [YogaSequence]
    @Environment(\.modelContext) private var modelContext

    @State private var showCreateSequence = false
    @State private var searchText = ""
    @State private var sequenceToDelete: YogaSequence?

    private var filteredSequences: [YogaSequence] {
        let trimmed = searchText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return sequences }
        return sequences.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sequências")
                        .font(.moonRounded(30, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    LightSearchBar(text: $searchText, placeholder: "Pesquisar sequências")
                        .padding(.horizontal, 20)

                    if sequences.isEmpty {
                        LightEmptyStateView(
                            icon: "sparkles",
                            title: "Nenhuma sequência ainda",
                            message: "Crie sua primeira sequência de ioga e comece a praticar."
                        )
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)
                    } else if filteredSequences.isEmpty {
                        LightEmptyStateView(
                            icon: "magnifyingglass",
                            title: "Nenhuma sequência encontrada",
                            message: "Tente pesquisar por outro nome."
                        )
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: 14) {

                            ForEach(filteredSequences) { seq in

                                NavigationLink(
                                    destination: SequenceDetailView(sequence: seq)
                                ) {

                                    SequenceListCard(sequence: seq)

                                }
                                .buttonStyle(.plain)

                                .contextMenu {

                                    Button {

                                        sequenceToDelete = seq

                                    } label: {

                                        Label(
                                            "Apagar",
                                            systemImage: "trash"
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 110) // espaço para a pill de navegação não cobrir conteúdo
                }
            }
            .background(MoonbendTheme.creamBackground.ignoresSafeArea())
            .navigationBarHidden(true)
            .overlay(alignment: .topTrailing) {
                LightIconButton(systemImage: "plus") {
                    showCreateSequence = true
                }
                .padding(.top, 16)
                .padding(.trailing, 20)
            }
            .fullScreenCover(isPresented: $showCreateSequence) {
                CreateSequenceFlowView()
            }
            .confirmationDialog(
                "Apagar esta sequência?",
                isPresented: Binding(get: { sequenceToDelete != nil }, set: { if !$0 { sequenceToDelete = nil } }),
                titleVisibility: .visible
            ) {
                Button("Apagar", role: .destructive) {
                    if let seq = sequenceToDelete {
                        modelContext.delete(seq)
                        try? modelContext.save()
                    }
                    sequenceToDelete = nil
                }
                Button("Cancelar", role: .cancel) { sequenceToDelete = nil }
            }
        }
    }
}

struct SequenceListCard: View {

    let sequence: YogaSequence

    var body: some View {

        HStack(spacing: 14) {

            // Foto da sequência
            if let imageData = sequence.imageData,
               let uiImage = UIImage(data: imageData) {

                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: 82,
                        height: 82
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 16
                        )
                    )

            } else {

                RoundedRectangle(
                    cornerRadius: 16
                )
                .fill(
                    Color.white.opacity(0.5)
                )
                .frame(
                    width: 82,
                    height: 82
                )
                .overlay {

                    Image(systemName: "figure.yoga")
                        .font(.system(size: 30))
                        .foregroundStyle(
                            MoonbendTheme.inkPrimary.opacity(0.5)
                        )
                }
            }



            VStack(
                alignment: .leading,
                spacing: 6
            ) {


                Text(sequence.name)

                    .font(
                        .moonRounded(
                            16,
                            weight: .bold
                        )
                    )

                    .foregroundStyle(
                        MoonbendTheme.inkPrimary
                    )

                    .lineLimit(2)



                Text(
                    sequence.sequenceDescription ??
                    "Uma sequência personalizada de yoga."
                )

                    .font(
                        .moonRounded(
                            12,
                            weight: .regular
                        )
                    )

                    .foregroundStyle(
                        MoonbendTheme.inkPrimary.opacity(0.7)
                    )

                    .lineLimit(3)


            }


            Spacer()

        }

        .padding(14)

        .background(

            RoundedRectangle(
                cornerRadius: 22
            )

            .fill(
                Color.white.opacity(0.73)
            )
        )
    }
}
