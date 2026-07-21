import SwiftUI
import SwiftData

/// Tela inicial — réplica fiel da referência visual enviada pela usuária:
/// fundo creme, cards brancos com sombra suave, blob de gradiente pastel,
/// pill de navegação inferior clara.
///
/// Conteúdo adaptado conforme pedido:
/// - "Namaste, {nome}" + "Let's bend?" no lugar de "Hello, Janani / Today's Summary"
/// - Sequência atual de dias praticados no lugar de "Tot Activities Today"
/// - Galeria horizontal "What are we doing today?" com todas as sequências
/// - Acessos rápidos para nova sequência e nova pose
struct HomeView: View {
    @Binding var selectedTab: Int

    @Query(sort: \YogaSequence.createdAt, order: .reverse) private var sequences: [YogaSequence]
    @Query private var poses: [Pose]
    @Query private var logs: [PracticeLog]

    @AppStorage("userName") private var userName: String = ""

    @State private var showNamePrompt = false
    @State private var tempName = ""
    @State private var showCreateSequence = false
    @State private var showAddPose = false
    @State private var sequenceToPractice: YogaSequence?

    private var practicedToday: Bool {
        logs.contains { Calendar.current.isDateInToday($0.day) }
    }

    private var currentStreak: Int {
        StreakCalculator.currentStreak(logs: logs)
    }

    private var longestStreak: Int {
        StreakCalculator.longestStreak(logs: logs)
    }

    private var initials: String {
        let trimmed = userName.trimmingCharacters(in: .whitespaces)
        guard let first = trimmed.first else { return "🌙" }
        return String(first).uppercased()
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    topBar
                    header
                    streakStat
                    todaysGallery
                    quickAccess
                    Spacer(minLength: 110) // espaço para a pill de navegação não cobrir conteúdo
                }
                .padding(.bottom, 10)
            }
            .background(MoonbendTheme.creamBackground.ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .tint(MoonbendTheme.inkPrimary)
        .onAppear {
            if userName.isEmpty { showNamePrompt = true }
        }
        .sheet(isPresented: $showNamePrompt) {
            NameEntrySheet(name: $tempName) {
                userName = tempName.trimmingCharacters(in: .whitespaces)
                showNamePrompt = false
            }
            .presentationDetents([.height(260)])
        }
        .sheet(isPresented: $showAddPose) {
            AddPoseView()
        }
        .fullScreenCover(isPresented: $showCreateSequence) {
            CreateSequenceFlowView()
        }
        .fullScreenCover(item: $sequenceToPractice) { seq in
            PracticeSequenceView(sequence: seq)
        }
    }

    // MARK: - Barra superior: grid, pontos, notificação, avatar (como na referência)
    private var topBar: some View {
        HStack(spacing: 10) {
            LightIconButton(systemImage: "square.grid.2x2.fill") {
                selectedTab = 2
            }

            PointsPill(points: logs.count * 10)

            Spacer()

            LightIconButton(systemImage: "bell.fill", showBadge: !practicedToday) {
                selectedTab = 3
            }

            AvatarButton(initials: initials) {
                tempName = userName
                showNamePrompt = true
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    // MARK: - "Namaste, {nome}" + "Let's bend?"
    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Namaste\(userName.isEmpty ? "" : ", \(userName)")")
                .font(.moonRounded(30, weight: .bold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text("Let's bend?")
                .font(.moonRounded(30, weight: .bold))
                .foregroundStyle(MoonbendTheme.inkSecondary)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Sequência atual de dias praticados (substitui "01 04 Tot Activities Today")
    private var streakStat: some View {
        HStack(alignment: .center) {
            HStack(alignment: .firstTextBaseline, spacing: 14) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%02d", currentStreak))
                        .font(.moonRounded(34, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                    Text(String(format: "%02d", longestStreak))
                        .font(.moonRounded(34, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkSecondary.opacity(0.35))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Sequência de dias")
                        .font(.moonRounded(13, weight: .medium))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                    Text("Atual / Recorde")
                        .font(.moonRounded(13, weight: .medium))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                }
            }

            Spacer()

            LightIconButton(systemImage: "calendar") {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Galeria horizontal "What are we doing today?"
    private var todaysGallery: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("What are we doing today?")
                .font(.moonRounded(20, weight: .bold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .padding(.horizontal, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    if sequences.isEmpty {
                        FeaturedEmptyCard {
                            showCreateSequence = true
                        }
                    } else {
                        ForEach(sequences) { seq in
                            FeaturedSequenceCard(sequence: seq) {
                                sequenceToPractice = seq
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Acessos rápidos: nova sequência e nova pose (estilo "Your Progress / Total Steps")
    private var quickAccess: some View {
        HStack(spacing: 14) {
            LightQuickAccessCard(
                icon: "plus",
                title: "Nova sequência",
                subtitle: "Monte seu fluxo"
            ) {
                showCreateSequence = true
            }

            LightQuickAccessCard(
                icon: "figure.yoga",
                title: "Nova pose",
                subtitle: "Adicionar à biblioteca"
            ) {
                showAddPose = true
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Sheet de primeiro acesso (pergunta o nome uma única vez)
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

            PrimaryButton(title: "Salvar", isDisabled: name.trimmingCharacters(in: .whitespaces).isEmpty) {
                onSave()
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding(.top, 30)
        .background(Color.white)
    }
}
