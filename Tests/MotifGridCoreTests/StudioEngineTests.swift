import Testing
@testable import MotifGridCore

@Suite("MotifGrid interaction model")
struct StudioEngineTests {
  @Test("Collider weights use normalized inverse-distance blending")
  func colliderWeightsNormalize() {
    let prompts = [
      PromptNode(id: 0, position: Point2D(x: 0, y: 0), text: "bluegrass banjo"),
      PromptNode(id: 1, position: Point2D(x: 10, y: 0), text: "drum and bass"),
    ]

    let weights = PromptMixer.weights(
      listener: Point2D(x: 2, y: 0),
      prompts: prompts
    )

    #expect(abs(weights.reduce(0, +) - 1) < 0.000_001)
    #expect(weights[0] > weights[1])
  }

  @Test("A listener on a prompt selects only that prompt")
  func colliderExactHit() {
    let prompts = [
      PromptNode(id: 0, position: Point2D(x: 4, y: 8), text: "piano"),
      PromptNode(id: 1, position: Point2D(x: 8, y: 4), text: "trumpet"),
    ]

    let weights = PromptMixer.weights(
      listener: Point2D(x: 4, y: 8),
      prompts: prompts
    )

    #expect(weights == [1, 0])
  }

  @Test("Jam preset navigation wraps in both directions")
  func jamPresetNavigationWraps() {
    var state = JamState(
      jamPresets: ["bluegrass banjo", "lo-fi hip hop"],
      soloPresets: ["fingerpicked acoustic guitar"]
    )

    state.previousPreset()
    #expect(state.prompt == "lo-fi hip hop")

    state.nextPreset()
    #expect(state.prompt == "bluegrass banjo")
  }

  @Test("Solo mode prefixes the model prompt without changing visible text")
  func soloModePrefix() {
    var state = JamState(
      jamPresets: ["bluegrass banjo"],
      soloPresets: ["grand piano"]
    )

    state.setSoloMode(true)

    #expect(state.prompt == "grand piano")
    #expect(state.enginePrompt == "SOLO grand piano")
  }

  @Test("Transport and MIDI note state are deterministic")
  func transportAndNotes() {
    var session = StudioSession()

    session.togglePlayback()
    session.noteOn(60)
    session.noteOn(60)
    session.noteOn(64)

    #expect(session.isPlaying)
    #expect(session.activeNotes == [60, 64])

    session.noteOff(60)
    session.togglePlayback()

    #expect(!session.isPlaying)
    #expect(session.activeNotes == [64])
  }

  @Test("MIDI pitch conversion uses A4 equals 440 Hz")
  func midiPitchConversion() {
    #expect(abs(Pitch.frequency(forMIDINote: 69) - 440) < 0.000_001)
    #expect(abs(Pitch.frequency(forMIDINote: 60) - 261.625_565) < 0.001)
  }
}
