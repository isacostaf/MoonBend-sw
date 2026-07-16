import SwiftUI
import SwiftData

/// Aba "Sequências": lista todas as sequências criadas em formato de grade
/// e permite iniciar a criação de uma nova.
struct SequencesListView: View {
    @Query(sort: \YogaSequence.createdAt, order: .reverse) private var sequences: [YogaSequence]
    @State private var showCreateSequence = false

    var body: some View {
        NavigationStack {
            ScrollView {
                if sequences.isEmpty {
                    EmptyStateView(
                        icon: "sparkles",
                        title: "Nenhuma sequência ainda",
                        message: "Crie sua primeira sequência de ioga e comece a praticar."
                    )
                    .padding(.top, 60)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                        ForEach(sequences) { seq in
                            NavigationLink(destination: SequenceDetailView(sequence: seq)) {
                                SequenceCard(sequence: seq)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                }
            }
            .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Sequências")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCreateSequence = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(MoonbendTheme.deepPurple)
                    }
                }
            }
            .fullScreenCover(isPresented: $showCreateSequence) {
                CreateSequenceFlowView()
            }
        }
    }
}
