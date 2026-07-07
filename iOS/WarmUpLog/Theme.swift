import SwiftUI

enum Theme {
    static let background = Color(hex: "0E1A14")
    static let accent = Color(hex: "3DDC97")
    static let accent2 = Color(hex: "F2B134")
    static let text = Color(hex: "EAF4EE")
    static let cardBackground = Color(hex: "0E1A14").opacity(0.6)

    static let titleFont: Font = .system(.title2, design: .rounded).weight(.bold)
    static let headlineFont: Font = .system(.headline, design: .rounded)
    static let bodyFont: Font = .system(.body, design: .rounded)
    static let captionFont: Font = .system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
