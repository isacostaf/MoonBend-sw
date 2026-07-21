import SwiftUI

// MARK: - Botão principal (pílula clara sobre o fundo escuro do app)
struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title).font(.moonRounded(16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(MoonbendTheme.deepPurple)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(isDisabled ? AnyShapeStyle(Color.white.opacity(0.15)) : AnyShapeStyle(MoonbendTheme.heroGradient))
            )
        }
        .disabled(isDisabled)
    }
}

// MARK: - Exibição de imagem (usada em cards de pose e sequência).
// A imagem já chega quadrada (cortada no ImagePickerButton), então aqui só
// precisamos preencher e cortar cantos — sem lógica extra de crop.
struct PoseImageView: View {
    let imageData: Data?
    var cornerRadius: CGFloat = 20

    var body: some View {
        Group {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ZStack {
                    MoonbendTheme.cardGradientDawn.opacity(0.5)
                    Image(systemName: "figure.yoga")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .clipped()
    }
}

// MARK: - Card de pose (biblioteca e seletor de poses)
struct PoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PoseImageView(imageData: pose.imageData)
                .aspectRatio(1, contentMode: .fit)

            Text(pose.name)
                .font(.moonRounded(14, weight: .medium))
                .foregroundStyle(MoonbendTheme.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Card de sequência (aba Sequências e carrossel da Home)
struct SequenceCard: View {
    let sequence: YogaSequence

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PoseImageView(imageData: sequence.imageData, cornerRadius: 24)
                .aspectRatio(1, contentMode: .fit)

            Text(sequence.name)
                .font(.moonRounded(16, weight: .semibold))
                .foregroundStyle(MoonbendTheme.textPrimary)
                .lineLimit(1)

            HStack(spacing: 12) {
                Label("\(sequence.poseCount) poses", systemImage: "figure.yoga")
                if sequence.totalDurationSeconds > 0 {
                    Label(formattedDuration(sequence.totalDurationSeconds), systemImage: "timer")
                }
            }
            .font(.moonRounded(12))
            .foregroundStyle(MoonbendTheme.textSecondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func formattedDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return m > 0 ? "\(m)min \(s)s" : "\(s)s"
    }
}

// MARK: - Cabeçalho de seção padrão
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.moonRounded(22, weight: .bold))
                .foregroundStyle(MoonbendTheme.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(.moonRounded(13))
                    .foregroundStyle(MoonbendTheme.textSecondary)
            }
        }
    }
}

// MARK: - Estado vazio
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
                .foregroundStyle(MoonbendTheme.textPrimary)
            Text(message)
                .font(.moonRounded(14))
                .foregroundStyle(MoonbendTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Chip de estatística rápida (linha de resumo na Home)
struct PillStatChip: View {
    let icon: String
    let text: String
    var isHighlighted: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.moonRounded(13, weight: .medium))
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .foregroundStyle(isHighlighted ? MoonbendTheme.deepPurple : MoonbendTheme.textPrimary)
        .background(
            Capsule().fill(isHighlighted ? AnyShapeStyle(Color.white) : AnyShapeStyle(Color.black.opacity(0.16)))
        )
    }
}

// MARK: - Card estilo checklist (equivalente ao card "NEW PLAN" da referência,
// que mostra itens como "Buy food / GYM / Invest" em formato de lista).
// Aqui usamos para mostrar as poses da sequência em destaque.
struct ChecklistBentoCard: View {
    let title: String
    let items: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.moonRounded(19, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)

            VStack(spacing: 8) {
                ForEach(Array(items.prefix(3).enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 8) {
                        Image(systemName: index == 0 ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(index == 0 ? MoonbendTheme.lavender : .white.opacity(0.5))
                        Text(item)
                            .font(.moonRounded(13, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(.white.opacity(0.08)))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(MoonbendTheme.cardGradientPlum)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}

// MARK: - Card "bento" (grade da Home, inspirado na referência visual)
struct BentoCard: View {
    let gradient: LinearGradient
    var imageData: Data? = nil
    let icon: String
    let title: String
    let subtitle: String
    var compact: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                Color.black.opacity(0.35)
            } else {
                gradient
            }

            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: compact ? 15 : 19))
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(Circle().fill(.white.opacity(0.15)))

                Spacer()

                Text(title)
                    .font(.moonRounded(compact ? 15 : 19, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                Text(subtitle)
                    .font(.moonRounded(11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(1)
            }
            .padding(14)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
    }
}

// MARK: - Card largo de criação (equivalente ao card "DESIGN SPRINT" da referência)
struct WideCreateCard: View {
    var body: some View {
        ZStack(alignment: .top) {
            MoonbendTheme.cardGradientDawn

            // Grabber decorativo no topo, no mesmo espírito da referência
            Capsule()
                .fill(MoonbendTheme.deepPurple.opacity(0.3))
                .frame(width: 30, height: 4)
                .padding(.top, 10)

            VStack(alignment: .leading, spacing: 6) {
                Spacer()
                Text("Nova sequência")
                    .font(.moonRounded(21, weight: .bold))
                    .foregroundStyle(MoonbendTheme.deepPurple)
                Text("Monte seu próprio fluxo de posturas")
                    .font(.moonRounded(13, weight: .medium))
                    .foregroundStyle(MoonbendTheme.deepPurple.opacity(0.75))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 110)
        .overlay(alignment: .bottomTrailing) {
            // Círculo pontilhado decorativo, igual ao da referência
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [1, 8]))
                .foregroundStyle(MoonbendTheme.deepPurple.opacity(0.35))
                .frame(width: 60, height: 60)
                .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }
}

// MARK: - Barra de pesquisa reutilizável (poses, sequências e seleção de poses)
struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Pesquisar"

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(MoonbendTheme.textSecondary)

            TextField(placeholder, text: $text)
                .font(.moonRounded(15))
                .foregroundStyle(MoonbendTheme.textPrimary)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(MoonbendTheme.textSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.black.opacity(0.16)))
    }
}

// MARK: - Chip redondo de tag, usado no carrossel de filtro da biblioteca de poses
struct TagFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.moonRounded(13, weight: .semibold))
                .foregroundStyle(isSelected ? MoonbendTheme.deepPurple : MoonbendTheme.textPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(isSelected ? AnyShapeStyle(MoonbendTheme.heroGradient) : AnyShapeStyle(Color.black.opacity(0.16)))
                )
                .overlay(
                    Capsule().stroke(Color.white.opacity(isSelected ? 0 : 0.12), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chip pequeno (não interativo), usado para mostrar tags dentro dos detalhes da pose
struct TagBadge: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.moonRounded(12, weight: .medium))
            .foregroundStyle(MoonbendTheme.deepPurple)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.85)))
    }
}

/// Campo simples para digitar e adicionar tags livres (a usuária cria as próprias tags).
struct TagEditor: View {
    @Binding var tags: [String]
    @State private var draft: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Adicionar tag (ex: força, manhã...)", text: $draft)
                    .font(.moonRounded(15))
                    .foregroundStyle(MoonbendTheme.textPrimary)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.14)))
                    .onSubmit(addTag)

                Button(action: addTag) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(MoonbendTheme.lavender)
                }
                .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if !tags.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        HStack(spacing: 6) {
                            Text(tag)
                                .font(.moonRounded(12, weight: .medium))
                            Button {
                                tags.removeAll { $0 == tag }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 9, weight: .bold))
                            }
                        }
                        .foregroundStyle(MoonbendTheme.textPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(Color.black.opacity(0.2)))
                    }
                }
            }
        }
    }

    private func addTag() {
        let trimmed = draft.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            draft = ""
            return
        }
        tags.append(trimmed)
        draft = ""
    }
}

/// Layout simples que quebra linha automaticamente (usado pelas tags no editor).
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        return CGSize(width: maxWidth, height: currentY + lineHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX, currentX > bounds.minX {
                currentX = bounds.minX
                currentY += lineHeight + spacing
                lineHeight = 0
            }
            subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(size))
            currentX += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}

// MARK: - Card horizontal de sequência para o carrossel "What are we doing today?" da Home
struct SequenceGalleryCard: View {
    let sequence: YogaSequence

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PoseImageView(imageData: sequence.imageData, cornerRadius: 22)
                .frame(width: 168, height: 130)

            VStack(alignment: .leading, spacing: 4) {
                Text(sequence.name)
                    .font(.moonRounded(15, weight: .semibold))
                    .foregroundStyle(MoonbendTheme.textPrimary)
                    .lineLimit(1)
                Label("\(sequence.poseCount) poses", systemImage: "figure.yoga")
                    .font(.moonRounded(11, weight: .medium))
                    .foregroundStyle(MoonbendTheme.textSecondary)
            }
            .padding(.top, 10)
            .padding(.horizontal, 4)
        }
        .padding(10)
        .frame(width: 188)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white.opacity(0.06))
                .overlay(RoundedRectangle(cornerRadius: 26, style: .continuous).stroke(Color.white.opacity(0.08), lineWidth: 1))
        )
    }
}

// MARK: - Botão de acesso rápido ("+ Nova sequência" / "+ Nova pose" da Home)
struct QuickAccessButton: View {
    let icon: String
    let title: String
    let gradient: LinearGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(Circle().fill(.white.opacity(0.2)))
                Text(title)
                    .font(.moonRounded(14, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer(minLength: 0)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(gradient))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ============ COMPONENTES DO TEMA CLARO (Home) ============
// Réplica fiel da referência visual: fundo creme, cards brancos com sombra
// suave, blob de gradiente pastel decorativo, pill de navegação inferior clara.

// MARK: - Botão circular branco (ícones do topo: grid, sino, calendário)
struct LightIconButton: View {
    let systemImage: String
    var showBadge: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: systemImage)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(MoonbendTheme.cardWhite))
                    .shadow(color: MoonbendTheme.paleShadow, radius: 6, y: 3)

                if showBadge {
                    Circle()
                        .fill(Color(hex: "E4573D"))
                        .frame(width: 9, height: 9)
                        .offset(x: -2, y: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pill branca com pontuação (troféu + número), como "780 pts" da referência
struct PointsPill: View {
    let points: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: "E7A93C"))
            Text("\(points)")
                .font(.moonRounded(14, weight: .bold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
            Text("pts")
                .font(.moonRounded(12, weight: .medium))
                .foregroundStyle(MoonbendTheme.inkSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Capsule().fill(MoonbendTheme.cardWhite))
        .shadow(color: MoonbendTheme.paleShadow, radius: 6, y: 3)
    }
}

// MARK: - Avatar circular do topo direito
struct AvatarButton: View {
    let initials: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(MoonbendTheme.pastelBlobGradient)
                Text(initials)
                    .font(.moonRounded(13, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 40, height: 40)
            .overlay(Circle().stroke(MoonbendTheme.cardWhite, lineWidth: 2))
            .shadow(color: MoonbendTheme.paleShadow, radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }
}

/// Blob de gradiente pastel borrado, decoração usada nos cards em destaque
/// (mesmo efeito visual do "orb" atrás do card "Dr. Anna G" na referência).
struct PastelBlob: View {
    var size: CGFloat = 130

    var body: some View {
        Circle()
            .fill(MoonbendTheme.pastelBlobGradient)
            .frame(width: size, height: size)
            .blur(radius: 18)
            .opacity(0.85)
    }
}

// MARK: - Card em destaque no estilo "Dr. Anna G" da referência, reaproveitado
// para mostrar cada sequência no carrossel "What are we doing today?".
struct FeaturedSequenceCard: View {
    let sequence: YogaSequence
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(sequence.name)
                                .font(.moonRounded(18, weight: .bold))
                                .foregroundStyle(MoonbendTheme.inkPrimary)
                                .lineLimit(1)
                            Text("\(sequence.poseCount) poses")
                                .font(.moonRounded(13))
                                .foregroundStyle(MoonbendTheme.inkSecondary)
                        }
                        Spacer(minLength: 40)
                    }

                    PastelBlob(size: 100)
                        .offset(x: 22, y: -14)
                        .allowsHitTesting(false)
                }
                .padding(.top, 4)

                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Poses")
                            .font(.moonRounded(11, weight: .medium))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                        Text("\(sequence.poseCount)")
                            .font(.moonRounded(15, weight: .semibold))
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                    }
                    Spacer()
                    Rectangle()
                        .fill(MoonbendTheme.inkSecondary.opacity(0.2))
                        .frame(width: 1, height: 30)
                    Spacer()
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Duração")
                            .font(.moonRounded(11, weight: .medium))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                        Text(sequence.totalDurationSeconds > 0 ? formattedDuration(sequence.totalDurationSeconds) : "Livre")
                            .font(.moonRounded(15, weight: .semibold))
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                    }
                }
                .padding(.top, 22)

                Divider()
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                HStack {
                    Text("Iniciar prática")
                        .font(.moonRounded(15, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                }
            }
            .padding(20)
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(MoonbendTheme.cardWhite)
                    .shadow(color: MoonbendTheme.paleShadow, radius: 16, y: 8)
            )
        }
        .buttonStyle(.plain)
    }

    private func formattedDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return m > 0 ? "\(m)min \(s)s" : "\(s)s"
    }
}

/// Card "convite para criar" no mesmo estilo claro, mostrado quando não há sequências ainda.
struct FeaturedEmptyCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Monte sua\nprimeira sequência")
                            .font(.moonRounded(18, weight: .bold))
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                        Text("Escolha as poses e comece a praticar")
                            .font(.moonRounded(13))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                    }
                    PastelBlob(size: 90)
                        .offset(x: 10, y: -10)
                        .allowsHitTesting(false)
                }

                Spacer(minLength: 0)

                HStack {
                    Text("Criar sequência")
                        .font(.moonRounded(15, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                }
            }
            .padding(20)
            .frame(width: 280, height: 210)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(MoonbendTheme.cardWhite)
                    .shadow(color: MoonbendTheme.paleShadow, radius: 16, y: 8)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Card pequeno de acesso rápido, no estilo "Your Progress / Total Steps" da referência
struct LightQuickAccessCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(MoonbendTheme.creamBackground))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.moonRounded(15, weight: .semibold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                    Text(subtitle)
                        .font(.moonRounded(12))
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(MoonbendTheme.cardWhite)
                    .shadow(color: MoonbendTheme.paleShadow, radius: 10, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pill de navegação inferior clara, réplica da barra da referência
// (ícones: início, poses, calendário, sequências) — fica fixa em todas as abas.
struct LightFloatingNavBar: View {
    let active: Int
    let onHome: () -> Void
    let onPoses: () -> Void
    let onCalendar: () -> Void
    let onSequences: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            navIcon("house.fill", tag: 0, action: onHome)
            Spacer()
            navIcon("figure.yoga", tag: 1, action: onPoses)
            Spacer()
            navIcon("dumbbell.fill", tag: 2, action: onSequences)
            Spacer()
            navIcon("calendar", tag: 3, action: onCalendar)
        }
        .padding(.horizontal, 26)
        .padding(.vertical, 16)
        .background(
            Capsule().fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 18, y: 8)
        )
    }

    private func navIcon(_ systemImage: String, tag: Int, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(active == tag ? MoonbendTheme.inkPrimary : MoonbendTheme.inkSecondary.opacity(0.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Botão principal claro (fundo tinta escura, texto branco) — CTA padrão nas abas claras
struct LightPrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon) }
                Text(title).font(.moonRounded(16, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(isDisabled ? AnyShapeStyle(MoonbendTheme.inkSecondary.opacity(0.35)) : AnyShapeStyle(MoonbendTheme.inkPrimary))
            )
        }
        .disabled(isDisabled)
    }
}

// MARK: - Cabeçalho de seção claro
struct LightSectionHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.moonRounded(22, weight: .bold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(.moonRounded(13))
                    .foregroundStyle(MoonbendTheme.inkSecondary)
            }
        }
    }
}

// MARK: - Estado vazio claro
struct LightEmptyStateView: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 44))
                .foregroundStyle(MoonbendTheme.inkSecondary.opacity(0.5))
            Text(title)
                .font(.moonRounded(17, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
            Text(message)
                .font(.moonRounded(14))
                .foregroundStyle(MoonbendTheme.inkSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Barra de pesquisa clara (card branco com sombra suave)
struct LightSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Pesquisar"

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(MoonbendTheme.inkSecondary)

            TextField(placeholder, text: $text)
                .font(.moonRounded(15))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .autocorrectionDisabled()

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(MoonbendTheme.inkSecondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 8, y: 3)
        )
    }
}

// MARK: - Chip redondo de tag (claro), usado no carrossel de filtro da biblioteca de poses
struct LightTagFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.moonRounded(13, weight: .semibold))
                .foregroundStyle(isSelected ? .white : MoonbendTheme.inkPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 11)
                .background(
                    Capsule().fill(isSelected ? AnyShapeStyle(MoonbendTheme.inkPrimary) : AnyShapeStyle(MoonbendTheme.cardWhite))
                        .shadow(color: MoonbendTheme.paleShadow, radius: 6, y: 3)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chip pequeno claro, para tags dentro de campos de edição
struct LightTagEditor: View {
    @Binding var tags: [String]
    @State private var draft: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Adicionar tag (ex: força, manhã...)", text: $draft)
                    .font(.moonRounded(15))
                    .foregroundStyle(MoonbendTheme.inkPrimary)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(MoonbendTheme.cardWhite))
                    .onSubmit(addTag)

                Button(action: addTag) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                }
                .disabled(draft.trimmingCharacters(in: .whitespaces).isEmpty)
            }

            if !tags.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        HStack(spacing: 6) {
                            Text(tag)
                                .font(.moonRounded(12, weight: .medium))
                            Button {
                                tags.removeAll { $0 == tag }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 9, weight: .bold))
                            }
                        }
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(MoonbendTheme.creamBackground))
                    }
                }
            }
        }
    }

    private func addTag() {
        let trimmed = draft.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !tags.contains(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            draft = ""
            return
        }
        tags.append(trimmed)
        draft = ""
    }
}

// MARK: - Card de pose claro (biblioteca e seletor de poses)
struct LightPoseCard: View {
    let pose: Pose

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PoseImageView(imageData: pose.imageData, cornerRadius: 16)
                .aspectRatio(1, contentMode: .fit)

            Text(pose.name)
                .font(.moonRounded(13, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 10, y: 4)
        )
    }
}

// MARK: - Card de sequência claro (aba Sequências)
struct LightSequenceCard: View {
    let sequence: YogaSequence

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            PoseImageView(imageData: sequence.imageData, cornerRadius: 18)
                .aspectRatio(1, contentMode: .fit)

            Text(sequence.name)
                .font(.moonRounded(15, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .lineLimit(1)

            HStack(spacing: 10) {
                Label("\(sequence.poseCount) poses", systemImage: "figure.yoga")
                if sequence.totalDurationSeconds > 0 {
                    Label(formattedDuration(sequence.totalDurationSeconds), systemImage: "timer")
                }
            }
            .font(.moonRounded(11))
            .foregroundStyle(MoonbendTheme.inkSecondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(MoonbendTheme.cardWhite)
                .shadow(color: MoonbendTheme.paleShadow, radius: 10, y: 4)
        )
    }

    private func formattedDuration(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return m > 0 ? "\(m)min \(s)s" : "\(s)s"
    }
}

// MARK: - Linha de item claro (usada nos detalhes de sequência e no builder)
struct LightItemRow<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(MoonbendTheme.cardWhite)
                    .shadow(color: MoonbendTheme.paleShadow, radius: 6, y: 3)
            )
    }
}

// MARK: - ============ FIM DOS COMPONENTES CLAROS PARTILHADOS ============

// MARK: - Barra flutuante inferior (equivalente à pílula "+ / microfone" da referência)
struct FloatingPillBar: View {
    let onCreate: () -> Void
    var onPracticeLast: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onCreate) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(MoonbendTheme.deepPurple)
                    .frame(width: 52, height: 52)
                    .background(Circle().fill(.white))
            }

            if let onPracticeLast {
                Button(action: onPracticeLast) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color.white.opacity(0.15)))
                }
            }
        }
        .padding(8)
        .background(Capsule().fill(.ultraThinMaterial))
        .background(Capsule().fill(Color.black.opacity(0.25)))
        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
    }
}
