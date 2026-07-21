import SwiftUI
import SwiftData
import UIKit

/// Aba "Poses" — biblioteca minimalista com busca,
/// filtros por tags e grade de imagens.
struct PosesLibraryView: View {

    @Query(sort: \Pose.createdAt) private var poses: [Pose]
    @Environment(\.modelContext) private var modelContext

    @State private var showAddPose = false
    @State private var searchText = ""
    @State private var selectedTags: Set<String> = []
    @State private var poseToDelete: Pose?


    // 3 colunas
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]


    /// Todas as tags únicas
    private var allTags: [String] {
        let unique = Set(poses.flatMap { $0.tags })
        return unique.sorted()
    }


    /// Filtro de busca e tags
    private var filteredPoses: [Pose] {

        poses.filter { pose in

            let matchesSearch =
            searchText.trimmingCharacters(in: .whitespaces).isEmpty
            ||
            pose.name.localizedCaseInsensitiveContains(searchText)


            let matchesTags =
            selectedTags.isEmpty
            ||
            !selectedTags.isDisjoint(with: Set(pose.tags))


            return matchesSearch && matchesTags
        }
    }



    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 18) {


                    Text("Poses")
                        .font(.moonRounded(30, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)
                        .padding(.horizontal, 20)
                        .padding(.top, 12)



                    LightSearchBar(
                        text: $searchText,
                        placeholder: "Pesquisar poses"
                    )
                    .padding(.horizontal, 20)



                    // Tags
                    if !allTags.isEmpty {

                        ScrollView(
                            .horizontal,
                            showsIndicators: false
                        ) {

                            HStack(spacing: 10) {

                                ForEach(allTags, id: \.self) { tag in


                                    LightTagFilterChip(
                                        title: tag,
                                        isSelected: selectedTags.contains(tag)
                                    ) {

                                        if selectedTags.contains(tag) {

                                            selectedTags.remove(tag)

                                        } else {

                                            selectedTags.insert(tag)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }




                    if poses.isEmpty {


                        LightEmptyStateView(
                            icon: "figure.yoga",
                            title: "Nenhuma pose ainda",
                            message: "Adicione sua primeira postura de ioga para começar sua biblioteca."
                        )
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)



                    } else if filteredPoses.isEmpty {


                        LightEmptyStateView(
                            icon: "magnifyingglass",
                            title: "Nenhuma pose encontrada",
                            message: "Tente outra busca ou remova os filtros."
                        )
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity)



                    } else {



                        LazyVGrid(
                            columns: columns,
                            spacing: 22
                        ) {


                            ForEach(filteredPoses) { pose in


                                NavigationLink(
                                    destination: PoseDetailView(pose: pose)
                                ) {


                                    MinimalPoseCell(
                                        pose: pose
                                    )

                                }
                                .buttonStyle(.plain)



                                .contextMenu {


                                    Button {

                                        poseToDelete = pose

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


                    Spacer(minLength: 110)

                }
            }


            .background(
                MoonbendTheme.creamBackground
                    .ignoresSafeArea()
            )


            .navigationBarHidden(true)



            .overlay(alignment: .topTrailing) {


                LightIconButton(
                    systemImage: "plus"
                ) {

                    showAddPose = true

                }
                .padding(.top,16)
                .padding(.trailing,20)

            }



            .sheet(
                isPresented: $showAddPose
            ) {

                AddPoseView()

            }



            .confirmationDialog(
                "Apagar esta pose?",
                isPresented: Binding(
                    get: {
                        poseToDelete != nil
                    },
                    set: {
                        if !$0 {
                            poseToDelete = nil
                        }
                    }
                ),
                titleVisibility: .visible
            ) {


                Button(
                    "Apagar",
                    role: .destructive
                ) {


                    if let pose = poseToDelete {

                        modelContext.delete(pose)

                        try? modelContext.save()
                    }


                    poseToDelete = nil
                }



                Button(
                    "Cancelar",
                    role: .cancel
                ) {

                    poseToDelete = nil

                }

            }
        }
    }
}





// MARK: - Célula minimalista da pose

struct MinimalPoseCell: View {
    let pose: Pose

    var body: some View {
        VStack(spacing: 8) {
            
            // Container da Imagem com proporção quadrada perfeita (1:1)
            Group {
                if let imageData = pose.imageData,
                   let uiImage = UIImage(data: imageData) {
                    
                    // Criamos um container geométrico para forçar o corte estrito
                    Color.clear
                        .aspectRatio(1, contentMode: .fill)
                        .overlay(
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    
                } else {
                    // Estado sem imagem (Placeholder)
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.5))
                        .aspectRatio(1, contentMode: .fill)
                        .overlay {
                            Image(systemName: "figure.yoga")
                                .font(.system(size: 28))
                                .foregroundStyle(
                                    MoonbendTheme.inkPrimary.opacity(0.5)
                                )
                        }
                }
            }
            
            // Texto da pose
            Text(pose.name)
                .font(.moonRounded(12, weight: .semibold))
                .foregroundStyle(MoonbendTheme.inkPrimary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32, alignment: .top)
        }
        .padding(.horizontal, 3)
    }
}
