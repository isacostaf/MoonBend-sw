import SwiftUI

/// Fundo "mesh gradient" pastel, recriando a paleta da referência visual
/// (lilás no topo, verde-oliva suave no meio, pêssego na base), montado com
/// camadas de RadialGradient para simular a suavidade de um mesh gradient
/// real, mais um véu escuro sutil por cima para garantir contraste do texto
/// branco — igual ao efeito visto na foto de referência.
struct MeshBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "D9C7EC"),
                    Color(hex: "C7C4B4"),
                    Color(hex: "E9C39C")
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            RadialGradient(
                colors: [Color(hex: "C6A6E0").opacity(0.55), .clear],
                center: .topLeading, startRadius: 10, endRadius: 420
            )
            RadialGradient(
                colors: [Color(hex: "9FAE86").opacity(0.35), .clear],
                center: .center, startRadius: 10, endRadius: 480
            )
            RadialGradient(
                colors: [Color(hex: "F0B98A").opacity(0.5), .clear],
                center: .bottomTrailing, startRadius: 10, endRadius: 460
            )

            // Véu escuro sutil: garante que o texto branco do título
            // tenha contraste suficiente, como na foto de referência.
            Color.black.opacity(0.08)
        }
    }
}
