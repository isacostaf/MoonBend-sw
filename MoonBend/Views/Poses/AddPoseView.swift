import SwiftUI
import SwiftData

/// Tela modal para cadastrar uma nova pose: foto + nome, conforme pedido.
/// A usuária pode criar quantas poses quiser.
struct AddPoseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var imageData: Data?

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && imageData != nil
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                ImagePickerButton(imageData: $imageData, size: 180)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Nome da postura")
                        .font(.moonRounded(13, weight: .medium))
                        .foregroundStyle(MoonbendTheme.softGray)
                    TextField("Ex: Postura da criança", text: $name)
                        .font(.moonRounded(16))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.08)))
                }
                .padding(.horizontal, 24)

                Spacer()

                PrimaryButton(title: "Salvar postura", icon: "checkmark", isDisabled: !isValid) {
                    let pose = Pose(
                        name: name.trimmingCharacters(in: .whitespaces),
                        imageData: imageData,
                        isCustom: true
                    )
                    modelContext.insert(pose)
                    try? modelContext.save()
                    dismiss()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .background(MoonbendTheme.backgroundGradient.ignoresSafeArea())
            .navigationTitle("Nova pose")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}
