import SwiftUI
import PhotosUI

/// Botão circular/quadrado que abre o seletor de fotos nativo (PhotosPicker).
/// Usa PHPicker por baixo dos panos, então NÃO exige permissão de galeria
/// no Info.plist — melhor experiência para a usuária.
struct ImagePickerButton: View {
    @Binding var imageData: Data?
    var placeholderSystemImage: String = "photo.on.rectangle.angled"
    var size: CGFloat = 160

    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            ZStack {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(MoonbendTheme.heroGradient.opacity(0.25))
                        .frame(width: size, height: size)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: placeholderSystemImage)
                                    .font(.system(size: 32))
                                Text("Adicionar foto")
                                    .font(.moonRounded(13, weight: .medium))
                            }
                            .foregroundStyle(MoonbendTheme.deepPurple)
                        )
                }

                // Selo de "editar" no canto — indica visualmente que é tocável
                Circle()
                    .fill(.white)
                    .frame(width: 34, height: 34)
                    .overlay(Image(systemName: "pencil").foregroundStyle(MoonbendTheme.deepPurple))
                    .shadow(color: MoonbendTheme.cardShadow, radius: 4)
                    .offset(x: size / 2 - 14, y: size / 2 - 14)
            }
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}
