import SwiftUI
import SwiftData

/// Tela de detalhes de uma pose (tema claro): foto grande, nome, tags e a
/// descrição (só aparece aqui, nunca no card). Permite editar ou apagar.
struct PoseDetailView: View {
    let pose: Pose
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var showEdit = false
    @State private var showDeleteConfirm = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PoseImageView(imageData: pose.imageData, cornerRadius: 28)
                    .frame(height: 260)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                VStack(alignment: .leading, spacing: 10) {
                    Text(pose.name)
                        .font(.moonRounded(26, weight: .bold))
                        .foregroundStyle(MoonbendTheme.inkPrimary)

                    if !pose.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(pose.tags, id: \.self) { tag in
                                    TagBadge(title: tag)
                                }
                            }
                        }
                    }

                    if let description = pose.poseDescription, !description.isEmpty {
                        Text(description)
                            .font(.moonRounded(15))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                            .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 20)

                HStack(spacing: 14) {
                    Button {
                        showEdit = true
                    } label: {
                        Label("Editar", systemImage: "pencil")
                            .font(.moonRounded(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(MoonbendTheme.cardWhite)
                                    .shadow(color: MoonbendTheme.paleShadow, radius: 8, y: 3)
                            )
                    }

                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Label("Apagar", systemImage: "trash")
                            .font(.moonRounded(15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(RoundedRectangle(cornerRadius: 18).fill(Color(hex: "E4573D").opacity(0.9)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 10)
        }
        .background(MoonbendTheme.creamBackground.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(MoonbendTheme.creamBackground, for: .navigationBar)
        .sheet(isPresented: $showEdit) {
            AddPoseView(existingPose: pose)
        }
        .confirmationDialog(
            "Apagar esta pose?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Apagar", role: .destructive) {
                modelContext.delete(pose)
                try? modelContext.save()
                dismiss()
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Essa pose será removida da biblioteca. Sequências que já usam essa pose manterão o item, mas sem a referência à pose.")
        }
    }
}
