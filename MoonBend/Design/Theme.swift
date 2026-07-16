import SwiftUI

/// Sistema de design do Moonbend: paleta feminina, suave e criativa
/// (lavanda + rosa blush + pêssego), com tipografia arredondada.
enum MoonbendTheme {
    // MARK: - Cores base
    static let lavender = Color(red: 0.75, green: 0.68, blue: 0.93)
    static let blush = Color(red: 0.98, green: 0.78, blue: 0.85)
    static let peach = Color(red: 1.0, green: 0.85, blue: 0.73)
    static let deepPurple = Color(red: 0.35, green: 0.22, blue: 0.55)
    static let cream = Color(red: 0.99, green: 0.97, blue: 0.94)
    static let softGray = Color(red: 0.45, green: 0.42, blue: 0.5)

    // MARK: - Gradientes
    /// Usado como fundo geral das telas (suave, quase imperceptível)
    static let backgroundGradient = LinearGradient(
        colors: [cream, blush.opacity(0.25)],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Usado em botões principais, tela de prática e destaques
    static let heroGradient = LinearGradient(
        colors: [lavender, blush],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardShadow = Color.purple.opacity(0.15)
}

extension Font {
    /// Fonte arredondada do sistema (dá o toque "amigável/feminino" sem precisar de fonte custom)
    static func moonRounded(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
