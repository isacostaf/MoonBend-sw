import SwiftUI
import SwiftData

/// Tela modal (tema claro) para cadastrar OU editar uma pose: foto + nome +
/// descrição opcional + tags. Quando `existingPose` é passado, o formulário
/// é pré-preenchido e o salvar atualiza a pose existente em vez de criar uma nova.
struct AddPoseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    /// Se presente, estamos em modo de edição.
    var existingPose: Pose?

    @State private var name: String = ""
    @State private var imageData: Data?
    @State private var descriptionText: String = ""
    @State private var tags: [String] = []

    private var isEditing: Bool { existingPose != nil }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && imageData != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    ImagePickerButton(imageData: $imageData, size: 180)
                        .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nome da postura")
                            .font(.moonRounded(13, weight: .medium))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                        TextField("Ex: Postura da criança", text: $name)
                            .font(.moonRounded(16))
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(MoonbendTheme.cardWhite))
                    }
                    .padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Descrição")
                                .font(.moonRounded(13, weight: .medium))
                                .foregroundStyle(MoonbendTheme.inkSecondary)
                            Text("(opcional)")
                                .font(.moonRounded(12))
                                .foregroundStyle(MoonbendTheme.inkSecondary.opacity(0.7))
                        }
                        TextEditor(text: $descriptionText)
                            .font(.moonRounded(15))
                            .foregroundStyle(MoonbendTheme.inkPrimary)
                            .scrollContentBackground(.hidden)
                            .frame(height: 100)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 16).fill(MoonbendTheme.cardWhite))
                    }
                    .padding(.horizontal, 24)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.moonRounded(13, weight: .medium))
                            .foregroundStyle(MoonbendTheme.inkSecondary)
                        LightTagEditor(tags: $tags)
                    }
                    .padding(.horizontal, 24)

                    LightPrimaryButton(
                        title: isEditing ? "Salvar alterações" : "Salvar postura",
                        icon: "checkmark",
                        isDisabled: !isValid
                    ) {
                        save()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            .background(MoonbendTheme.creamBackground.ignoresSafeArea())
            .navigationTitle(isEditing ? "Editar pose" : "Nova pose")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(MoonbendTheme.creamBackground, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onAppear(perform: loadExistingIfNeeded)
        }
    }

    private func loadExistingIfNeeded() {
        guard let existingPose else { return }
        name = existingPose.name
        imageData = existingPose.imageData
        descriptionText = existingPose.poseDescription ?? ""
        tags = existingPose.tags
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = descriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
        let finalDescription = trimmedDescription.isEmpty ? nil : trimmedDescription

        if let existingPose {
            existingPose.name = trimmedName
            existingPose.imageData = imageData
            existingPose.poseDescription = finalDescription
            existingPose.tags = tags
        } else {
            let pose = Pose(
                name: trimmedName,
                imageData: imageData,
                isCustom: true,
                poseDescription: finalDescription,
                tags: tags
            )
            modelContext.insert(pose)
        }
        try? modelContext.save()
        dismiss()
    }
}
