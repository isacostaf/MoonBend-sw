import SwiftUI

extension Color {
    /// Permite criar cores a partir de códigos hexadecimais (ex: "E9C39C"),
    /// o que facilita reproduzir com precisão a paleta de uma referência visual.
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue >> 16) & 0xFF) / 255
        let g = Double((rgbValue >> 8) & 0xFF) / 255
        let b = Double(rgbValue & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
