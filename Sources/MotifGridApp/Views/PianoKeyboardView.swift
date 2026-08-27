import SwiftUI

struct PianoKeyboardView: View {
  @Bindable var model: StudioModel
  var compact = false

  private let whiteNotes = [60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79]
  private let blackMap: [(index: Int, note: Int)] = [
    (0, 61), (1, 63), (3, 66), (4, 68), (5, 70), (7, 73), (8, 75), (10, 78),
  ]

  var body: some View {
    GeometryReader { proxy in
      let keyWidth = proxy.size.width / CGFloat(whiteNotes.count)
      ZStack(alignment: .topLeading) {
        HStack(spacing: 2) {
          ForEach(Array(whiteNotes.enumerated()), id: \.offset) { index, note in
            PianoKey(
              note: note,
              label: compact ? octaveLabel(index) : whiteLabel(index),
              isBlack: false,
              isActive: model.session.activeNotes.contains(note),
              noteOn: model.noteOn,
              noteOff: model.noteOff
            )
          }
        }
        ForEach(blackMap, id: \.note) { item in
          PianoKey(
            note: item.note,
            label: compact ? "" : blackLabel(item.note),
            isBlack: true,
            isActive: model.session.activeNotes.contains(item.note),
            noteOn: model.noteOn,
            noteOff: model.noteOff
          )
          .frame(width: keyWidth * 0.62, height: proxy.size.height * 0.62)
          .offset(x: (CGFloat(item.index) + 1) * keyWidth - keyWidth * 0.31)
        }
      }
    }
  }

  private func whiteLabel(_ index: Int) -> String {
    ["A", "S", "D", "F", "G", "H", "J", "K", "L", ";", "'", "\\"][index]
  }

  private func blackLabel(_ note: Int) -> String {
    let labels = [61: "W", 63: "E", 66: "T", 68: "Y", 70: "U", 73: "O", 75: "P"]
    return labels[note] ?? ""
  }

  private func octaveLabel(_ index: Int) -> String {
    index % 2 == 0 ? "C\(4 + index / 7)" : ""
  }
}

private struct PianoKey: View {
  let note: Int
  let label: String
  let isBlack: Bool
  let isActive: Bool
  let noteOn: (Int) -> Void
  let noteOff: (Int) -> Void
  @State private var isPressed = false

  var body: some View {
    RoundedRectangle(cornerRadius: isBlack ? 2 : 3)
      .fill(keyColor)
      .overlay(alignment: .bottom) {
        Text(label)
          .font(.system(size: isBlack ? 13 : 12, weight: .medium))
          .foregroundStyle(isBlack ? .white : .black)
          .padding(.bottom, 8)
      }
      .overlay(
        RoundedRectangle(cornerRadius: isBlack ? 2 : 3)
          .stroke(Color.black.opacity(0.34), lineWidth: 1)
      )
      .shadow(color: .black.opacity(isBlack ? 0.42 : 0.12), radius: 2, y: 2)
      .contentShape(Rectangle())
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { _ in
            guard !isPressed else { return }
            isPressed = true
            noteOn(note)
          }
          .onEnded { _ in
            isPressed = false
            noteOff(note)
          }
      )
  }

  private var keyColor: Color {
    if isActive { return MotifTheme.mint }
    return isBlack ? Color.black : Color(white: 0.96)
  }
}
