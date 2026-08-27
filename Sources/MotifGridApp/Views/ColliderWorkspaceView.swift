import MotifGridCore
import SwiftUI

struct ColliderWorkspaceView: View {
  @Bindable var model: StudioModel

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 14) {
        RoundIconButton(symbol: "arrow.counterclockwise", diameter: 42) { model.reset() }
        RoundIconButton(
          symbol: model.isPlaying ? "pause.fill" : "play.fill",
          prominent: true,
          diameter: 56
        ) { model.togglePlayback() }
        RoundIconButton(symbol: "speaker.wave.2.fill", diameter: 42) {}
        Spacer()
        Text("MODEL")
          .font(.system(size: 11, weight: .semibold))
          .tracking(1)
          .foregroundStyle(.white.opacity(0.67))
        Text("mrt2_base")
          .font(.system(size: 12, weight: .semibold))
        Image(systemName: "chevron.down").font(.system(size: 10))
        Image(systemName: "slider.horizontal.3")
          .font(.system(size: 17))
          .padding(.leading, 18)
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)

      ColliderCanvas(model: model)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

      HStack(spacing: 22) {
        MetricLabel(name: "FRAME:", value: "63%")
        MetricLabel(name: "BUFFER:", value: "171 MS")
        Spacer()
        RoundIconButton(symbol: "circle.grid.cross", diameter: 36) {}
        RoundIconButton(symbol: "car.side.fill", diameter: 36) {}
        Slider(value: $model.promptStrength).frame(width: 140)
        RoundIconButton(symbol: "figure.dance", diameter: 36) {}
        RoundIconButton(symbol: "square.and.arrow.up", diameter: 42) {}
        RoundIconButton(symbol: "plus", diameter: 42) {
          addColliderPrompt()
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, 18)
    }
    .background(Color(red: 0.11, green: 0.115, blue: 0.12))
  }

  private func addColliderPrompt() {
    guard model.colliderPrompts.count < 6 else { return }
    let id = (model.colliderPrompts.map(\.id).max() ?? -1) + 1
    model.colliderPrompts.append(
      PromptNode(
        id: id,
        position: Point2D(x: 0.50, y: 0.34),
        text: "new musical texture",
        colorIndex: id % MotifTheme.promptColors.count
      )
    )
  }
}

private struct ColliderCanvas: View {
  @Bindable var model: StudioModel

  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      ZStack {
        Canvas { context, _ in
          for (index, prompt) in model.colliderPrompts.enumerated() {
            var path = Path()
            path.move(to: point(model.listener, in: size))
            path.addLine(to: point(prompt.position, in: size))
            let color = MotifTheme.promptColors[prompt.colorIndex % MotifTheme.promptColors.count]
            let opacity = max(0.20, min(0.76, model.colliderWeights[index] + 0.18))
            context.stroke(
              path,
              with: .color(color.opacity(opacity)),
              style: StrokeStyle(lineWidth: 1, dash: [5, 6])
            )
          }
        }

        ForEach(Array(model.colliderPrompts.enumerated()), id: \.element.id) { index, prompt in
          ColliderNode(
            text: prompt.text,
            color: MotifTheme.promptColors[prompt.colorIndex % MotifTheme.promptColors.count],
            weight: model.colliderWeights[index]
          )
          .position(point(prompt.position, in: size))
          .gesture(
            DragGesture()
              .onChanged { gesture in
                model.colliderPrompts[index].position = normalized(gesture.location, in: size)
              }
          )
        }

        Circle()
          .fill(.white)
          .frame(width: 50, height: 50)
          .shadow(color: .black.opacity(0.25), radius: 5, y: 3)
          .position(point(model.listener, in: size))
          .gesture(
            DragGesture(minimumDistance: 0)
              .onChanged { gesture in
                model.listener = normalized(gesture.location, in: size)
              }
          )
      }
    }
    .padding(.horizontal, 50)
  }

  private func point(_ point: Point2D, in size: CGSize) -> CGPoint {
    CGPoint(x: point.x * size.width, y: point.y * size.height)
  }

  private func normalized(_ point: CGPoint, in size: CGSize) -> Point2D {
    Point2D(
      x: min(0.96, max(0.04, point.x / max(1, size.width))),
      y: min(0.92, max(0.08, point.y / max(1, size.height)))
    )
  }
}

private struct ColliderNode: View {
  let text: String
  let color: Color
  let weight: Double

  var body: some View {
    VStack(spacing: 5) {
      Text(text)
        .font(.system(size: 11, weight: .medium))
        .lineLimit(1)
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .background(Capsule().fill(.black.opacity(0.84)))
      ZStack {
        Circle().fill(color.opacity(0.12))
        Circle().trim(from: 0, to: max(0.04, weight)).stroke(color, lineWidth: 3)
          .rotationEffect(.degrees(-90))
        Path { path in
          path.move(to: CGPoint(x: 20, y: 20))
          path.addLine(to: CGPoint(x: 20, y: 4))
          path.addLine(to: CGPoint(x: 34, y: 13))
          path.closeSubpath()
        }
        .fill(color)
      }
      .frame(width: 42, height: 42)
    }
  }
}
