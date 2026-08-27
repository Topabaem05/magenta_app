import AVFoundation
import MotifGridCore

@MainActor
final class LocalSynthesizer {
  private let engine = AVAudioEngine()
  private var voices: [Int: AVAudioPlayerNode] = [:]

  init() {
    configureAudio()
  }

  func noteOn(_ note: Int) {
    noteOff(note)

    let format = AVAudioFormat(standardFormatWithSampleRate: 48_000, channels: 1)!
    let frameCount = AVAudioFrameCount(format.sampleRate * 1.5)
    guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }
    buffer.frameLength = frameCount

    let frequency = Pitch.frequency(forMIDINote: note)
    let sampleRate = format.sampleRate
    let attackFrames = max(1, Int(sampleRate * 0.012))
    let releaseFrames = max(1, Int(sampleRate * 0.12))
    guard let samples = buffer.floatChannelData?[0] else { return }

    for frame in 0..<Int(frameCount) {
      let time = Double(frame) / sampleRate
      let attack = min(1, Float(frame) / Float(attackFrames))
      let remaining = Int(frameCount) - frame
      let release = min(1, Float(remaining) / Float(releaseFrames))
      let envelope = min(attack, release) * 0.20
      let fundamental = sin(2 * .pi * frequency * time)
      let harmonic = sin(2 * .pi * frequency * 2 * time) * 0.22
      samples[frame] = Float(fundamental + harmonic) * envelope
    }

    let player = AVAudioPlayerNode()
    engine.attach(player)
    engine.connect(player, to: engine.mainMixerNode, format: format)
    ensureEngineIsRunning()
    player.scheduleBuffer(buffer, at: nil, options: .loops)
    player.play()
    voices[note] = player
  }

  func noteOff(_ note: Int) {
    guard let player = voices.removeValue(forKey: note) else { return }
    player.stop()
    engine.detach(player)
  }

  func playPulse(root: Int) {
    noteOn(root)
  }

  func stopAll() {
    for note in Array(voices.keys) {
      noteOff(note)
    }
  }

  private func configureAudio() {
    let session = AVAudioSession.sharedInstance()
    try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
    try? session.setPreferredSampleRate(48_000)
    try? session.setActive(true)
  }

  private func ensureEngineIsRunning() {
    guard !engine.isRunning else { return }
    engine.prepare()
    try? engine.start()
  }
}
