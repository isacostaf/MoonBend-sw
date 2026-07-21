import SwiftUI

/// Sistema de design do Moonbend — v2, inspirado no visual de referência
/// enviado pela usuária: fundo escuro tipo "mesh gradient", cards estilo
/// bento com gradientes coloridos, tipografia grande e arredondada.
enum MoonbendTheme {
    // MARK: - Tons de fundo (escuro, "noturno")
    static let nightBase = Color(red: 0.08, green: 0.07, blue: 0.11)
    static let nightPlum = Color(red: 0.17, green: 0.11, blue: 0.19)
    static let nightSage = Color(red: 0.13, green: 0.15, blue: 0.12)

    // MARK: - Cores de destaque (mantêm o espírito feminino/suave pedido)
    static let lavender = Color(red: 0.75, green: 0.68, blue: 0.93)
    static let blush = Color(red: 0.98, green: 0.78, blue: 0.85)
    static let peach = Color(red: 1.0, green: 0.85, blue: 0.73)
    static let deepPurple = Color(red: 0.35, green: 0.22, blue: 0.55) // usado como texto sobre superfícies CLARAS
    static let softGray = Color(red: 0.45, green: 0.42, blue: 0.5)   // usado como texto secundário sobre superfícies CLARAS

    // MARK: - Texto sobre o fundo escuro
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)

    // MARK: - Gradiente claro usado em botões/badges de destaque
    static let heroGradient = LinearGradient(
        colors: [lavender, blush],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Gradientes "bento" para os cards da Home (inspirados na referência)
    static let cardGradientPlum = LinearGradient(
        colors: [Color(red: 0.26, green: 0.15, blue: 0.21), Color(red: 0.12, green: 0.08, blue: 0.12)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let cardGradientMoss = LinearGradient(
        colors: [Color(red: 0.32, green: 0.36, blue: 0.24), Color(red: 0.17, green: 0.20, blue: 0.15)],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    static let cardGradientDawn = LinearGradient(
        colors: [Color(hex: "7FC8C2"), peach, blush, lavender],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    static let cardShadow = Color.black.opacity(0.35)

    // MARK: - Paleta CLARA usada na Home, replicando com precisão a referência
    // enviada (fundo creme, cards brancos, textos escuros, blob gradiente pastel).
    static let creamBackground = Color(hex: "F6F1EA")
    static let cardWhite = Color(hex: "FFFFFF")
    static let inkPrimary = Color(hex: "241F1A")
    static let inkSecondary = Color(hex: "938D84")
    static let paleShadow = Color.black.opacity(0.07)

    /// Blob de gradiente pastel usado como decoração nos cards claros
    /// (mesmo espírito de cor do "orb" atrás do card "Dr. Anna G" da referência).
    static let pastelBlobGradient = LinearGradient(
        colors: [Color(hex: "7FC8C2"), peach, blush, lavender],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

extension Font {
    /// Fonte arredondada do sistema (toque amigável, sem precisar de fonte custom)
    static func moonRounded(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}
