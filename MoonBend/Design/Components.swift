import SwiftUI

// MARK: - Botão principal reutilizável (usado em todas as telas de ação)
struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.moonRounded(16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isDisabled ? AnyShapeStyle(Color.gray.opacity(0.4)) : AnyShapeStyle(MoonbendTheme.heroGradient))
            )
        }
        .disabled(isDisabled)
    }
}

// MARK: - Exibição de imagem de pose com fallback elegante (quando não há foto)
struct PoseImageView: View {
    let imageData: Data?
    var cornerRadius: CGFloat = 20

    var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    MoonbendTheme.heroGradient.opacity(0.3)
                    Image(systemName: "figure.yoga")
                        .font(.system(size: 28))
                        .foregroundStyle(MoonbendTheme.deepPurple.opacity(0.6))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}

// MARK: - Card de pose usado na biblioteca
struct PoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PoseImageView(imageData: pose.imageData)
                .aspectRatio(1, contentMode: .fit)

            Text(pose.name)
                .font(.moonRounded(14, weight: .medium))
                .foregroundStyle(MoonbendTheme.deepPurple)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Card de sequência usado na aba Sequências e na Home
struct SequenceCard: View {
    let sequence: YogaSequence

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PoseImageView(imageData: sequence.imageData, cornerRadius: 24)
                .frame(height: 140)

            Text(sequence.name)
                .font(.moonRounded(16, weight: .semibold))
                .foregroundStyle(MoonbendTheme.deepPurple)
                .lineLimit(1)

            HStack(spacing: 12) {
                Label("\(sequence.poseCount) poses", systemImage: "figure.yoga")
                if sequence.totalDurationSeconds > 0 {
                    Label(formattedDuration(sequence.totalDurationSeconds), systemImage: "timer")
                }
            }
            .font(.moonRounded(12))
            .foregroundStyle(MoonbendTheme.softGray)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white)
                .shadow(color: MoonbendTheme.cardShadow, radius: 10, y: 6)
        )
    }

    private func formattedDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return m > 0 ? "\(m)min \(s)s" : "\(s)s"
    }
}

// MARK: - Cabeçalho de seção padrão (título + subtítulo opcional)
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.moonRounded(22, weight: .bold))
                .foregroundStyle(MoonbendTheme.deepPurple)
            if let subtitle {
                Text(subtitle)
                    .font(.moonRounded(13))
                    .foregroundStyle(MoonbendTheme.softGray)
            }
        }
    }
}

// MARK: - Estado vazio (usado quando não há poses ou sequências ainda)
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(MoonbendTheme.lavender)
            Text(title)
                .font(.moonRounded(17, weight: .semibold))
                .foregroundStyle(MoonbendTheme.deepPurple)
            Text(message)
                .font(.moonRounded(14))
                .foregroundStyle(MoonbendTheme.softGray)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}
