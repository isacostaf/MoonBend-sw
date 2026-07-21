import UIKit

/// Utilitários de imagem usados para corrigir o bug de fotos não-quadradas:
/// toda foto adicionada (pose ou sequência) passa por aqui ANTES de ser salva,
/// garantindo que o dado já nasce quadrado — não depende de nenhuma view
/// "adivinhar" como cortar depois.
extension UIImage {

    /// Corta a imagem no centro para um quadrado perfeito (proporção 1:1).
    func croppedToSquare() -> UIImage {
        let side = min(size.width, size.height)
        let originX = (size.width - side) / 2
        let originY = (size.height - side) / 2

        guard let cgImage else { return self }

        // O CGImage trabalha em pixels reais, então precisamos escalar o
        // recorte pela escala da imagem (importante em telas Retina).
        let scaledRect = CGRect(
            x: originX * scale,
            y: originY * scale,
            width: side * scale,
            height: side * scale
        )

        guard let croppedCGImage = cgImage.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }

    /// Reduz a resolução (mantendo qualidade visual) para não inflar o
    /// banco de dados local com fotos gigantes tiradas em câmeras modernas.
    func resized(maxDimension: CGFloat) -> UIImage {
        let largestSide = max(size.width, size.height)
        guard largestSide > maxDimension else { return self }

        let scaleFactor = maxDimension / largestSide
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
