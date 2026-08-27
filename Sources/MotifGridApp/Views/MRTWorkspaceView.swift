import MotifGridCore
import SwiftUI

struct MRTWorkspaceView: View {
  @Bindable var model: StudioModel
  @State private var promptDraft = ""

  var body: some View {
    GeometryReader { proxy in
      VStack(spacing: 0) {
        HStack(spacing: 24) {
          promptColumn
            .frame(width: proxy.size.width * 0.41)
          controlColumn
        }
        .padding(16)
        .frame(maxHeight: .infinity)
        transport
          .frame(height: 90)
      }
    }
    .background(MotifTheme.background)
  }

  private var promptColumn: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 0) {
        Text("Prompts")
          .foregroundStyle(.black)
          .padding(.horizontal, 16)
          .frame(height: 32)
          .background(RoundedRectangle(cornerRadius: 4).fill(.white.opacity(0.92)))
        Text("Hypersurface")
          .foregroundStyle(.white.opacity(0.52))
          .padding(.horizontal, 16)
          .frame(height: 32)
          .background(MotifTheme.panel)
        Spacer()
        Text("MODEL")
          .font(.system(size: 11, weight: .semibold))
          .tracking(1)
          .foregroundStyle(.white.opacity(0.65))
        Text("mrt2_base")
          .font(.system(size: 12, weight: .semibold))
          .padding(.leading, 10)
        Image(systemName: "chevron.down")
          .font(.system(size: 10))
          .foregroundStyle(.white.opacity(0.6))
          .padding(.leading, 8)
      }
      .frame(height: 36)

      ForEach($model.prompts) { $prompt in
        HStack(spacing: 12) {
          HStack {
            TextField("Prompt", text: $prompt.text)
              .textFieldStyle(.plain)
            Image(systemName: "xmark")
              .foregroundStyle(.white.opacity(0.44))
              .onTapGesture {
                model.prompts.removeAll { $0.id == prompt.id }
              }
          }
          .padding(.horizontal, 14)
          .frame(height: 40)
          .background(RoundedRectangle(cornerRadius: 5).fill(MotifTheme.raised))

          Slider(value: $prompt.weight)
            .tint(MotifTheme.promptColors[prompt.colorIndex % MotifTheme.promptColors.count])
            .frame(maxWidth: .infinity)
        }
      }

      Spacer()

      HStack(spacing: 8) {
        Text("Prompt Strength")
          .font(.system(size: 11))
          .foregroundStyle(.white.opacity(0.65))
        Image(systemName: "info.circle")
          .font(.system(size: 10))
          .foregroundStyle(.white.opacity(0.4))
        Slider(value: $model.promptStrength)
          .tint(MotifTheme.mint)
      }

      HStack(spacing: 10) {
        TextField("Type a prompt", text: $promptDraft)
          .textFieldStyle(.plain)
          .padding(.horizontal, 14)
          .frame(height: 44)
          .background(RoundedRectangle(cornerRadius: 5).fill(MotifTheme.raised))
        Button {
          addPrompt()
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 17))
            .foregroundStyle(.white.opacity(0.64))
            .frame(width: 34, height: 34)
        }
        .buttonStyle(.plain)
      }
    }
  }

  private var controlColumn: some View {
    VStack(spacing: 16) {
      HStack(spacing: 22) {
        Dial(value: model.temperature, title: "Temperature", valueText: "1.00", tint: MotifTheme.mint)
        Dial(value: model.topK / 120, title: "Top-K Sampling", valueText: "100", tint: MotifTheme.mint)
        CompactToggle(title: "No Drums", isOn: $model.noDrums)
        Spacer()
      }
      .padding(16)
      .frame(height: 112)
      .motifPanel()

      HStack(spacing: 16) {
        PanelTitle("Note controls") {
          VStack(spacing: 16) {
            LabeledSlider(title: "Note Strength", value: $model.noteStrength)
            CompactToggle(title: "Solo", isOn: $model.solo)
            CompactToggle(title: "MIDI Gate", isOn: $model.midiGate)
            CompactToggle(title: "Auto-Strum", isOn: $model.autoStrum)
          }
        }
        .frame(width: 200)

        PanelTitle("Memory banks") {
          LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            MemoryButton(title: "BANK 1", accent: true)
            MemoryButton(title: "EMPTY", outlined: true)
            MemoryButton(title: "BANK 2", accent: true)
            MemoryButton(title: "SILENCE")
            MemoryButton(title: "BANK 3", accent: true)
            MemoryButton(title: "CUSTOM")
          }
        }
      }
      .frame(maxHeight: .infinity)
    }
  }

  private var transport: some View {
    HStack(spacing: 12) {
      RoundIconButton(symbol: "arrow.counterclockwise", diameter: 40) { model.reset() }
      RoundIconButton(
        symbol: model.isPlaying ? "pause.fill" : "play.fill",
        prominent: true,
        diameter: 56
      ) { model.togglePlayback() }
      RoundIconButton(symbol: "speaker.wave.2.fill", diameter: 40) {}
      VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 12) {
          Text("MIDI INPUT")
          Text("COMPUTER KEYBOARD")
            .foregroundStyle(.white.opacity(0.9))
          Circle().fill(.white.opacity(0.26)).frame(width: 7, height: 7)
        }
        .font(.system(size: 11, weight: .semibold))
        .tracking(0.7)
        .foregroundStyle(.white.opacity(0.56))
        PianoKeyboardView(model: model, compact: true)
      }
      Spacer(minLength: 8)
      VStack(alignment: .leading, spacing: 8) {
        MetricLabel(name: "FRAME:", value: "61%")
        MetricLabel(name: "BUFFER:", value: "43 MS")
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 10)
    .background(Color(red: 0.105, green: 0.11, blue: 0.12))
    .overlay(alignment: .top) { Rectangle().fill(MotifTheme.border).frame(height: 1) }
  }

  private func addPrompt() {
    let text = promptDraft.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !text.isEmpty else { return }
    let id = (model.prompts.map(\.id).max() ?? -1) + 1
    model.prompts.append(
      PromptRow(id: id, text: text, weight: 0.5, colorIndex: id % MotifTheme.promptColors.count)
    )
    promptDraft = ""
  }
}

private struct Dial: View {
  let value: Double
  let title: String
  let valueText: String
  let tint: Color

  var body: some View {
    HStack(spacing: 10) {
      ZStack {
        Circle().stroke(.white.opacity(0.12), lineWidth: 2)
        Circle()
          .trim(from: 0.08, to: min(0.92, 0.08 + value * 0.72))
          .stroke(tint, style: StrokeStyle(lineWidth: 2, lineCap: .round))
          .rotationEffect(.degrees(90))
        Capsule().fill(.white.opacity(0.7)).frame(width: 2, height: 15).offset(y: -7)
          .rotationEffect(.degrees(-125 + value * 250))
      }
      .frame(width: 56, height: 56)
      VStack(alignment: .leading, spacing: 3) {
        Text(title).font(.system(size: 12)).foregroundStyle(.white.opacity(0.65))
        Text(valueText).font(.system(size: 13, weight: .bold)).foregroundStyle(tint)
      }
    }
  }
}

private struct MemoryButton: View {
  let title: String
  var accent = false
  var outlined = false

  var body: some View {
    Button {} label: {
      HStack(spacing: 9) {
        Circle()
          .fill(accent ? MotifTheme.mint : Color.clear)
          .overlay(Circle().stroke(.white.opacity(0.3), lineWidth: accent ? 0 : 1))
          .frame(width: 7, height: 7)
        Text(title)
          .font(.system(size: 10, weight: .medium))
        Spacer()
        Image(systemName: "arrow.counterclockwise")
          .font(.system(size: 11))
          .foregroundStyle(.white.opacity(0.75))
      }
      .padding(.horizontal, 12)
      .frame(height: 44)
      .background(RoundedRectangle(cornerRadius: 8).fill(MotifTheme.raised.opacity(0.62)))
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(outlined ? MotifTheme.mint : MotifTheme.border, lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
  }
}
