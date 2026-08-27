import Foundation
import MotifGridCore
import Observation

@MainActor
@Observable
final class StudioModel {
  var session = StudioSession()
  var jam = JamState()
  var prompts = [
    PromptRow(id: 0, text: "piano", weight: 0.68, colorIndex: 0),
    PromptRow(id: 1, text: "trumpet", weight: 0.24, colorIndex: 1),
  ]
  var promptStrength = 0.54
  var noteStrength = 0.72
  var temperature = 1.0
  var topK = 100.0
  var noDrums = false
  var solo = false
  var midiGate = false
  var autoStrum = false
  var listener = Point2D(x: 0.58, y: 0.50)
  var colliderPrompts = [
    PromptNode(
      id: 0,
      position: Point2D(x: 0.42, y: 0.18),
      text: "fingerpicked acoustic guitar",
      colorIndex: 0
    ),
    PromptNode(
      id: 1,
      position: Point2D(x: 0.26, y: 0.72),
      text: "lo-fi hip hop",
      colorIndex: 2
    ),
    PromptNode(
      id: 2,
      position: Point2D(x: 0.72, y: 0.72),
      text: "drum and bass",
      colorIndex: 1
    ),
  ]

  let synth = LocalSynthesizer()

  init(arguments: [String] = ProcessInfo.processInfo.arguments) {
    guard let marker = arguments.firstIndex(of: "--workspace"),
      arguments.indices.contains(marker + 1)
    else { return }

    let requested = arguments[marker + 1]
    if let workspace = StudioWorkspace.allCases.first(where: {
      $0.rawValue.caseInsensitiveCompare(requested) == .orderedSame
    }) {
      session.workspace = workspace
    }
  }

  var workspace: StudioWorkspace {
    get { session.workspace }
    set { session.workspace = newValue }
  }

  var isPlaying: Bool { session.isPlaying }

  var colliderWeights: [Double] {
    PromptMixer.weights(listener: listener, prompts: colliderPrompts)
  }

  func togglePlayback() {
    session.togglePlayback()
    if session.isPlaying {
      synth.playPulse(root: workspace == .jam ? 55 : 48)
    } else {
      synth.stopAll()
    }
  }

  func noteOn(_ note: Int) {
    session.noteOn(note)
    synth.noteOn(note)
  }

  func noteOff(_ note: Int) {
    session.noteOff(note)
    synth.noteOff(note)
  }

  func reset() {
    synth.stopAll()
    session = StudioSession()
  }
}
