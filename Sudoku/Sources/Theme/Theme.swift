import SwiftUI
import UIKit

enum Theme {
    static let accent = Color(hex: 0x1A73E8)
    static let givenText = Color(light: 0x101418, dark: 0xF2F4F7)
    static let userText = Color(light: 0x1A73E8, dark: 0x6EA8FE)
    static let errorText = Color(hex: 0xD93025)

    static let background = Color(light: 0xF2F4F7, dark: 0x0B0E12)
    static let cellBackground = Color(light: 0xFFFFFF, dark: 0x171B21)

    static let selectedCell = Color(light: 0xBDD7F5, dark: 0x28486E)
    static let peerCell = Color(light: 0xE7EEF7, dark: 0x1E2732)
    static let sameNumber = Color(light: 0xC8DCF5, dark: 0x2F4E78)

    static let gridThin = Color(light: 0xC3CAD4, dark: 0x38414C)
    static let gridThick = Color(light: 0x2B3A55, dark: 0x9AA6B8)

    static let padBackground = Color(light: 0xE4E9F1, dark: 0x20262E)
    static let padHighlight = Color(light: 0xD2DDEB, dark: 0x2B3542)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: alpha)
    }

    init(light: UInt, dark: UInt) {
        self.init(uiColor: UIColor { trait in
            let hex = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                           green: CGFloat((hex >> 8) & 0xFF) / 255,
                           blue: CGFloat(hex & 0xFF) / 255,
                           alpha: 1)
        })
    }
}
