import SwiftUI

struct JamWorkspaceView: View {
  @Bindable var model: StudioModel

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        HStack(spacing: 22) {
          leftControls
            .frame(width: 164)
          promptStage
          rightControls
            .frame(width: 168)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .frame(height: proxy.size.height * 0.52)
        .background(MotifTheme.amber)

        PianoKeyboardView(model: model)
          .frame(maxHeight: .infinity)

        footer
          .frame(height: 64)
      }
    }
  }

  private var leftControls: some View {
    VStack(spacing: 14) {
      HStack(spacing: 0) {
        modeButton("Solo", enabled: model.jam.isSoloMode) {
          model.jam.setSoloMode(true)
        }
        modeButton("Jam", enabled: !model.jam.isSoloMode) {
          model.jam.setSoloMode(false)
        }
      }
      .padding(3)
      .background(RoundedRectangle(cornerRadius: 10).fill(MotifTheme.background))

      HStack(spacing: 24) {
        VStack(spacing: 8) {
          VerticalSlider(value: $model.jam.chaos, tint: MotifTheme.amber)
          Text("Chaos").font(.system(size: 11)).foregroundStyle(.black)
        }
        VStack(spacing: 8) {
          VerticalSlider(value: $model.jam.volume, tint: .white)
          Text("Volume").font(.system(size: 11)).foregroundStyle(.black)
        }
      }
      .padding(.horizontal, 18)
    }
  }

  private var promptStage: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10).fill(MotifTheme.background)
      HStack(spacing: 14) {
        Button { model.jam.previousPreset() } label: {
          Image(systemName: "arrow.left")
            .font(.system(size: 19, weight: .medium))
            .frame(width: 52, height: 56)
            .background(Circle().fill(MotifTheme.raised))
        }
        .buttonStyle(.plain)

        TextField("Describe a sound", text: $model.jam.prompt)
          .font(.system(size: 34, weight: .regular))
          .foregroundStyle(MotifTheme.amber)
          .textFieldStyle(.plain)
          .multilineTextAlignment(.center)
          .minimumScaleFactor(0.65)

        Button { model.jam.nextPreset() } label: {
          Image(systemName: "arrow.right")
            .font(.system(size: 19, weight: .medium))
            .frame(width: 52, height: 56)
            .background(Circle().fill(MotifTheme.raised))
        }
        .buttonStyle(.plain)
      }
      .padding(.horizontal, 14)

      HStack(spacing: 8) {
        Spacer()
        Image(systemName: "externaldrive.fill")
        Image(systemName: "doc.badge.plus")
      }
      .font(.system(size: 14))
      .foregroundStyle(MotifTheme.amber)
      .padding(14)
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
  }

  private var rightControls: some View {
    VStack(spacing: 14) {
      HStack(spacing: 9) {
        RoundIconButton(symbol: "arrow.clockwise", diameter: 44) { model.jam.nextPreset() }
        Button { model.togglePlayback() } label: {
          Image(systemName: model.isPlaying ? "pause.fill" : "play.fill")
            .foregroundStyle(.black)
            .frame(width: 62, height: 44)
            .background(RoundedRectangle(cornerRadius: 8).fill(.white))
        }
        .buttonStyle(.plain)
        RoundIconButton(symbol: "slider.horizontal.3", diameter: 44) {}
      }

      Text("Strength")
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(.black)
      HStack(spacing: 24) {
        VStack(spacing: 8) {
          VerticalSlider(value: $model.jam.noteStrength)
          Text("Notes").font(.system(size: 11)).foregroundStyle(.black)
        }
        VStack(spacing: 8) {
          VerticalSlider(value: $model.jam.styleStrength)
          Text("Style").font(.system(size: 11)).foregroundStyle(.black)
        }
      }
      .padding(.horizontal, 22)
    }
  }

  private var footer: some View {
    HStack(spacing: 16) {
      Text("MODEL")
      Text("mrt2_base").foregroundStyle(.white.opacity(0.92))
      Image(systemName: "chevron.down")
      Text("MIDI INPUT")
      Text("COMPUTER KEYBOARD").foregroundStyle(.white.opacity(0.92))
      Circle().fill(.white.opacity(0.3)).frame(width: 7, height: 7)
      Spacer()
      MetricLabel(name: "FRAME:", value: "65%")
      MetricLabel(name: "BUFFER SIZE:", value: "43 MS")
      Image(systemName: "line.3.horizontal")
        .font(.system(size: 24))
        .foregroundStyle(.white.opacity(0.22))
    }
    .padding(.horizontal, 16)
    .font(.system(size: 11, weight: .semibold))
    .tracking(0.6)
    .foregroundStyle(.white.opacity(0.54))
    .background(.black)
  }

  private func modeButton(_ title: String, enabled: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Text(title)
        .font(.system(size: 13, weight: .medium))
        .foregroundStyle(enabled ? MotifTheme.amber : .white.opacity(0.55))
        .frame(maxWidth: .infinity)
        .frame(height: 38)
        .background(
          RoundedRectangle(cornerRadius: 7).fill(enabled ? MotifTheme.raised : Color.clear)
        )
    }
    .buttonStyle(.plain)
  }
}
