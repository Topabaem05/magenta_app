import SwiftUI

struct RoundIconButton: View {
  let symbol: String
  var prominent = false
  var diameter: CGFloat = 48
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: symbol)
        .font(.system(size: diameter * 0.32, weight: .bold))
        .foregroundStyle(prominent ? .black : .white)
        .frame(width: diameter, height: diameter)
        .background(Circle().fill(prominent ? Color.white : MotifTheme.raised))
    }
    .buttonStyle(.plain)
  }
}

struct CompactToggle: View {
  let title: String
  @Binding var isOn: Bool

  var body: some View {
    Toggle(title, isOn: $isOn)
      .toggleStyle(.switch)
      .controlSize(.mini)
      .font(.system(size: 12))
      .foregroundStyle(.white.opacity(0.78))
  }
}

struct MetricLabel: View {
  let name: String
  let value: String

  var body: some View {
    HStack(spacing: 8) {
      Text(name)
      Text(value).foregroundStyle(.white.opacity(0.72))
    }
    .font(.system(size: 10, weight: .medium))
    .tracking(0.6)
    .foregroundStyle(.white.opacity(0.48))
  }
}

struct LabeledSlider: View {
  let title: String
  @Binding var value: Double
  var tint = MotifTheme.mint
  var valueText: String?

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        Text(title)
        Spacer()
        if let valueText {
          Text(valueText).foregroundStyle(tint)
        }
      }
      .font(.system(size: 12, weight: .medium))
      .foregroundStyle(.white.opacity(0.72))
      Slider(value: $value)
        .tint(tint)
    }
  }
}

struct VerticalSlider: View {
  @Binding var value: Double
  var tint = Color.white

  var body: some View {
    GeometryReader { proxy in
      let usable = max(1, proxy.size.height - 22)
      ZStack(alignment: .bottom) {
        Capsule().fill(Color.black.opacity(0.82)).frame(width: 22)
        Capsule()
          .fill(tint.opacity(0.32))
          .frame(width: 22, height: max(11, usable * value + 11))
        Circle()
          .fill(Color.white)
          .shadow(color: .black.opacity(0.22), radius: 2, y: 1)
          .frame(width: 24, height: 24)
          .offset(y: -usable * value)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .contentShape(Rectangle())
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { gesture in
            value = min(1, max(0, 1 - (gesture.location.y - 11) / usable))
          }
      )
    }
  }
}

struct PanelTitle<Content: View>: View {
  let title: String
  @ViewBuilder let content: Content

  init(_ title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  var body: some View {
    ZStack(alignment: .topLeading) {
      content
        .padding(15)
        .motifPanel()
      Text(title.uppercased())
        .font(.system(size: 10, weight: .medium))
        .tracking(1.1)
        .foregroundStyle(.white.opacity(0.58))
        .padding(.horizontal, 7)
        .background(MotifTheme.background)
        .offset(x: 12, y: -6)
    }
  }
}
