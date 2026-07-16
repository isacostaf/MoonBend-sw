import SwiftUI

/// Tela de prática guiada em tela cheia. Regras implementadas conforme pedido:
/// - Se o item tem tempo pré-determinado, o cronômetro conta e avança
///   automaticamente para a próxima pose ao chegar em zero.
/// - Sempre existe um botão "Próxima pose" para pular manualmente.
/// - Se o item NÃO tem tempo, só é possível avançar tocando em "Próxima pose".
/// - As próximas duas poses aparecem como preview menor, para acompanhamento.
struct PracticeSequenceView: View {
    let sequence: YogaSequence
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0
    @State private var remainingSeconds: Int = 0
    @State private var isPaused = false
    @State private var isFinished = false

    // Timer de 1 segundo — pausável através da flag isPaused
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var items: [SequenceItem] { sequence.sortedItems }
    private var currentItem: SequenceItem? {
        items.indices.contains(currentIndex) ? items[currentIndex] : nil
    }

    var body: some View {
        ZStack {
            MoonbendTheme.heroGradient.ignoresSafeArea()

            if isFinished || currentItem == nil {
                finishedView
            } else {
                VStack(spacing: 24) {
                    header
                    Spacer()
                    currentPoseView
                    Spacer()
                    nextPreview
                    controls
                }
                .padding(20)
            }
        }
        .onAppear { setupCurrentItem() }
        .onReceive(timer) { _ in
            guard !isPaused, let item = currentItem, item.hasTimer, !isFinished else { return }
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                advance()
            }
        }
    }

    // MARK: - Cabeçalho: fechar, nome da sequência, progresso
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.white.opacity(0.9))
            }
            Spacer()
            Text(sequence.name)
                .font(.moonRounded(15, weight: .semibold))
                .foregroundStyle(.white)
            Spacer()
            Text("\(currentIndex + 1)/\(items.count)")
                .font(.moonRounded(14, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
        }
    }

    // MARK: - Foco principal: pose atual em destaque + cronômetro
    @ViewBuilder
    private var currentPoseView: some View {
        if let item = currentItem {
            VStack(spacing: 20) {
                if item.itemType == .pose, let pose = item.pose {
                    PoseImageView(imageData: pose.imageData, cornerRadius: 32)
                        .frame(width: 260, height: 260)
                        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)

                    Text(pose.name)
                        .font(.moonRounded(26, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                } else {
                    ZStack {
                        Circle().fill(.white.opacity(0.15)).frame(width: 260, height: 260)
                        Image(systemName: "wind")
                            .font(.system(size: 70))
                            .foregroundStyle(.white)
                    }
                    Text("Descanso / transição")
                        .font(.moonRounded(26, weight: .bold))
                        .foregroundStyle(.white)
                }

                if item.hasTimer {
                    Text(timeString(remainingSeconds))
                        .font(.moonRounded(40, weight: .bold))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                } else {
                    Text("Sem tempo definido")
                        .font(.moonRounded(15))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
    }

    // MARK: - Preview das próximas 2 poses (menor, para acompanhamento)
    private var nextPreview: some View {
        HStack(spacing: 14) {
            ForEach(Array(items.dropFirst(currentIndex + 1).prefix(2).enumerated()), id: \.offset) { _, item in
                VStack(spacing: 6) {
                    if item.itemType == .pose, let pose = item.pose {
                        PoseImageView(imageData: pose.imageData, cornerRadius: 16)
                            .frame(width: 64, height: 64)
                        Text(pose.name)
                            .font(.moonRounded(11, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                    } else {
                        ZStack {
                            Circle().fill(.white.opacity(0.15)).frame(width: 64, height: 64)
                            Image(systemName: "wind").foregroundStyle(.white)
                        }
                        Text("Descanso")
                            .font(.moonRounded(11, weight: .medium))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
                .opacity(0.8)
            }
        }
    }

    // MARK: - Controles: pausar (se tiver timer) e avançar manualmente
    private var controls: some View {
        HStack(spacing: 20) {
            if currentItem?.hasTimer == true {
                Button {
                    isPaused.toggle()
                } label: {
                    Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                }
            }

            Button {
                advance()
            } label: {
                Text("Próxima pose")
                    .font(.moonRounded(16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(MoonbendTheme.deepPurple)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            }
        }
    }

    // MARK: - Tela final ao concluir todas as poses
    private var finishedView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(.white)
            Text("Prática concluída! 🌙")
                .font(.moonRounded(24, weight: .bold))
                .foregroundStyle(.white)
            Text("Namaste. Sinta a energia da sua prática.")
                .font(.moonRounded(15))
                .foregroundStyle(.white.opacity(0.9))

            Button {
                dismiss()
            } label: {
                Text("Concluir")
                    .font(.moonRounded(16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundStyle(MoonbendTheme.deepPurple)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
        }
        .padding(40)
    }

    // MARK: - Lógica de avanço/estado

    private func setupCurrentItem() {
        guard let item = currentItem else { isFinished = true; return }
        remainingSeconds = item.hasTimer ? item.durationSeconds : 0
        isPaused = false
    }

    private func advance() {
        if currentIndex + 1 < items.count {
            currentIndex += 1
            setupCurrentItem()
        } else {
            isFinished = true
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
