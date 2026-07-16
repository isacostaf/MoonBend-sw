import SwiftUI
import SwiftData

/// Tela inicial: saudação "Namaste, [nome]", atalhos rápidos, sequências
/// recentes e um resumo (quantas poses/sequências a usuária já criou).
struct HomeView: View {
    @Query(sort: \YogaSequence.createdAt, order: .reverse) private var sequences: [YogaSequence]
    @Query private var poses: [Pose]

    /// Nome salvo localmente (perguntado apenas uma vez, sem precisar de login)
    @AppStorage("userName") private var userName: String = ""

    @State private var showNamePrompt = false
    @State private var tempName = ""
    @State private var showCreateSequence = false
    @State private var sequenceToPractice: YogaSequence?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    quickActions
                    if !sequences.isEmpty {
                        recentSequences
                    }
                    summaryCards
                }
                .padding(.bottom, 30)
            }
            .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .onAppear {
            if userName.isEmpty { showNamePrompt = true }
        }
        // Pergunta o nome apenas na primeira vez que o app é aberto
        .sheet(isPresented: $showNamePrompt) {
            NameEntrySheet(name: $tempName) {
                userName = tempName.trimmingCharacters(in: .whitespaces)
                showNamePrompt = false
            }
            .presentationDetents([.height(260)])
        }
        // Fluxo completo de criação de sequência (3 passos)
        .fullScreenCover(isPresented: $showCreateSequence) {
            CreateSequenceFlowView()
        }
        // Modo prática abre em tela cheia
        .fullScreenCover(item: $sequenceToPractice) { seq in
            PracticeSequenceView(sequence: seq)
        }
    }

    // MARK: - Cabeçalho "Namaste, nome"
    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Namaste\(userName.isEmpty ? "" : ", \(userName)") 🌙")
                .font(.moonRounded(28, weight: .bold))
                .foregroundStyle(MoonbendTheme.deepPurple)
            Text("Respire fundo e comece sua prática de hoje")
                .font(.moonRounded(15))
                .foregroundStyle(MoonbendTheme.softGray)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    // MARK: - Atalhos rápidos
    private var quickActions: some View {
        HStack(spacing: 14) {
            Button {
                showCreateSequence = true
            } label: {
                QuickActionTile(icon: "plus.circle.fill", title: "Nova\nsequência")
            }

            NavigationLink(destination: PosesLibraryView()) {
                QuickActionTile(icon: "figure.yoga", title: "Biblioteca\nde poses")
            }

            if let last = sequences.first {
                Button {
                    sequenceToPractice = last
                } label: {
                    QuickActionTile(icon: "play.circle.fill", title: "Praticar\núltima")
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Carrossel de sequências recentes
    private var recentSequences: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Suas sequências")
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sequences) { seq in
                        NavigationLink(destination: SequenceDetailView(sequence: seq)) {
                            SequenceCard(sequence: seq)
                                .frame(width: 220)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Cards de resumo (poses e sequências cadastradas)
    private var summaryCards: some View {
        HStack(spacing: 14) {
            SummaryStatCard(value: "\(poses.count)", label: "Poses cadastradas", icon: "figure.yoga")
            SummaryStatCard(value: "\(sequences.count)", label: "Sequências criadas", icon: "sparkles")
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Subcomponentes privados da Home

private struct QuickActionTile: View {
    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(title)
                .font(.moonRounded(12, weight: .medium))
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(MoonbendTheme.heroGradient)
                .shadow(color: MoonbendTheme.cardShadow, radius: 8, y: 4)
        )
    }
}

private struct SummaryStatCard: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(MoonbendTheme.lavender)
            Text(value)
                .font(.moonRounded(24, weight: .bold))
                .foregroundStyle(MoonbendTheme.deepPurple)
            Text(label)
                .font(.moonRounded(12))
                .foregroundStyle(MoonbendTheme.softGray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white)
                .shadow(color: MoonbendTheme.cardShadow, radius: 8, y: 4)
        )
    }
}

private struct NameEntrySheet: View {
    @Binding var name: String
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Como podemos te chamar? 🌸")
                .font(.moonRounded(20, weight: .bold))
                .foregroundStyle(MoonbendTheme.deepPurple)

            TextField("Seu nome", text: $name)
                .font(.moonRounded(16))
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                .padding(.horizontal, 20)

            PrimaryButton(title: "Continuar", isDisabled: name.trimmingCharacters(in: .whitespaces).isEmpty) {
                onSave()
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding(.top, 30)
    }
}
