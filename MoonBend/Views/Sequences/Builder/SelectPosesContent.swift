import SwiftUI
import SwiftData

/// Passo 2 do fluxo de criação:
/// Seleção de poses usando exatamente o mesmo layout da biblioteca de poses.
struct SelectPosesContent: View {

    @ObservedObject var viewModel: SequenceBuilderViewModel
    let onContinue: () -> Void

    @Query(sort: \Pose.createdAt)
    private var poses: [Pose]

    @State private var searchText = ""


    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]


    private var filteredPoses: [Pose] {

        let trimmed = searchText.trimmingCharacters(
            in: .whitespaces
        )

        guard !trimmed.isEmpty else {
            return poses
        }

        return poses.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed)
        }
    }



    var body: some View {

        VStack(spacing: 0) {


            LightSectionHeader(
                title: "Escolha as poses",
                subtitle: "Passo 2 de 3 — toque quantas vezes quiser"
            )
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )



            LightSearchBar(
                text: $searchText,
                placeholder: "Pesquisar poses"
            )
            .padding(.horizontal, 20)
            .padding(.top, 14)



            ScrollView {


                if filteredPoses.isEmpty {

                    LightEmptyStateView(
                        icon: "magnifyingglass",
                        title: "Nenhuma pose encontrada",
                        message: "Tente pesquisar por outro nome."
                    )
                    .padding(.top, 40)


                } else {


                    LazyVGrid(
                        columns: columns,
                        spacing: 22
                    ) {


                        ForEach(filteredPoses) { pose in


                            Button {

                                viewModel.addPose(pose)

                            } label: {


                                ZStack(alignment: .topTrailing) {


                                    MinimalPoseCell(
                                        pose: pose
                                    )



                                    let count = viewModel.items.filter {
                                        $0.pose?.id == pose.id
                                    }.count



                                    if count > 0 {


                                        Text("\(count)")
                                            .font(
                                                .moonRounded(
                                                    11,
                                                    weight: .bold
                                                )
                                            )
                                            .foregroundStyle(.white)
                                            .frame(
                                                width: 22,
                                                height: 22
                                            )
                                            .background(
                                                Circle()
                                                    .fill(
                                                        MoonbendTheme.inkPrimary
                                                    )
                                            )
                                            .offset(
                                                x: 5,
                                                y: -5
                                            )

                                    }

                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 160)

                }
            }
        }


        .background(
            MoonbendTheme.creamBackground
                .ignoresSafeArea()
        )


        .navigationBarTitleDisplayMode(.inline)

        .toolbarBackground(
            MoonbendTheme.creamBackground,
            for: .navigationBar
        )



        // Barra inferior fixa
        .safeAreaInset(edge: .bottom) {


            VStack(spacing: 10) {


                if !viewModel.items.isEmpty {


                    ScrollView(
                        .horizontal,
                        showsIndicators: false
                    ) {


                        HStack(spacing: 8) {


                            ForEach(viewModel.items) { item in


                                if let pose = item.pose {


                                    PoseImageView(
                                        imageData: pose.imageData,
                                        cornerRadius: 10
                                    )
                                    .frame(
                                        width: 40,
                                        height: 40
                                    )

                                }
                            }
                        }
                        .padding(.horizontal, 16)

                    }

                }



                LightPrimaryButton(
                    title: "Continuar (\(viewModel.items.count) selecionadas)",
                    isDisabled: viewModel.items.isEmpty
                ) {

                    onContinue()

                }
                .padding(.horizontal, 20)

            }

            .padding(.top, 10)
            .padding(.bottom, 16)
            .background(
                .ultraThinMaterial
            )
        }
    }
}
