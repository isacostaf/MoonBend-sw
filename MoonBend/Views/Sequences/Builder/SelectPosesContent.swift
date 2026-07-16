import SwiftUI
import SwiftData

/// Passo 2 do fluxo de criação: mostra TODAS as poses (do sistema + criadas
/// pela usuária) em grade. Tocar numa pose adiciona ela ao final da sequência
/// em construção — pode tocar na mesma pose quantas vezes quiser (repetição).
struct SelectPosesContent: View {
    @ObservedObject var viewModel: SequenceBuilderViewModel
    let onContinue: () -> Void

    @Query(sort: \Pose.createdAt) private var poses: [Pose]
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Escolha as poses", subtitle: "Passo 2 de 3 — toque quantas vezes quiser")
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(poses) { pose in
                        Button {
                            viewModel.addPose(pose)
                        } label: {
                            VStack(spacing: 6) {
                                ZStack(alignment: .topTrailing) {
                                    PoseImageView(imageData: pose.imageData, cornerRadius: 16)
                                        .aspectRatio(1, contentMode: .fit)

                                    // Selo mostrando quantas vezes essa pose já foi adicionada
                                    let count = viewModel.items.filter { $0.pose?.id == pose.id }.count
                                    if count > 0 {
                                        Text("\(count)")
                                            .font(.moonRounded(11, weight: .bold))
                                            .foregroundStyle(.white)
                                            .frame(width: 20, height: 20)
                                            .background(Circle().fill(MoonbendTheme.deepPurple))
                                            .offset(x: 6, y: -6)
                                    }
                                }
                                Text(pose.name)
                                    .font(.moonRounded(12, weight: .medium))
                                    .foregroundStyle(MoonbendTheme.deepPurple)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 160)
            }
        }
        .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        // Barra inferior fixa com preview das poses escolhidas + botão continuar
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 10) {
                if !viewModel.items.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(viewModel.items) { item in
                                if let pose = item.pose {
                                    PoseImageView(imageData: pose.imageData, cornerRadius: 10)
                                        .frame(width: 40, height: 40)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                PrimaryButton(
                    title: "Continuar (\(viewModel.items.count) selecionadas)",
                    isDisabled: viewModel.items.isEmpty
                ) {
                    onContinue()
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 10)
            .padding(.bottom, 16)
            .background(.ultraThinMaterial)
        }
    }
}
