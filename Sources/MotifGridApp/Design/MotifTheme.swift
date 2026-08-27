import SwiftUI

enum MotifTheme {
  static let background = Color(red: 0.075, green: 0.078, blue: 0.085)
  static let panel = Color(red: 0.105, green: 0.11, blue: 0.12)
  static let raised = Color(red: 0.18, green: 0.19, blue: 0.20)
  static let border = Color.white.opacity(0.13)
  static let secondary = Color.white.opacity(0.62)
  static let mint = Color(red: 0.35, green: 0.95, blue: 0.80)
  static let blue = Color(red: 0.42, green: 0.66, blue: 1.0)
  static let pink = Color(red: 1.0, green: 0.24, blue: 0.53)
  static let amber = Color(red: 1.0, green: 0.73, blue: 0.20)
  static let promptColors = [blue, pink, amber, mint]
}

extension View {
  func motifPanel(cornerRadius: CGFloat = 14) -> some View {
    background(
      RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        .fill(MotifTheme.panel)
        .overlay(
          RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .stroke(MotifTheme.border, lineWidth: 1)
        )
    )
  }
}
