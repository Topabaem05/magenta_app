import Foundation

public struct Point2D: Equatable, Sendable {
  public var x: Double
  public var y: Double

  public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

public struct PromptNode: Equatable, Identifiable, Sendable {
  public let id: Int
  public var position: Point2D
  public var text: String
  public var colorIndex: Int

  public init(id: Int, position: Point2D, text: String, colorIndex: Int = 0) {
    self.id = id
    self.position = position
    self.text = text
    self.colorIndex = colorIndex
  }
}

public enum PromptMixer {
  private static let exactHitThreshold = 0.000_001

  public static func weights(listener: Point2D, prompts: [PromptNode]) -> [Double] {
    guard !prompts.isEmpty else { return [] }

    let squaredDistances = prompts.map { prompt in
      let x = prompt.position.x - listener.x
      let y = prompt.position.y - listener.y
      return (x * x) + (y * y)
    }

    if let exactIndex = squaredDistances.firstIndex(where: { $0 < exactHitThreshold }) {
      return prompts.indices.map { $0 == exactIndex ? 1 : 0 }
    }

    let inverseDistances = squaredDistances.map { 1 / $0 }
    let total = inverseDistances.reduce(0, +)
    guard total > 0 else {
      return Array(repeating: 1 / Double(prompts.count), count: prompts.count)
    }
    return inverseDistances.map { $0 / total }
  }
}

public struct JamState: Equatable, Sendable {
  public let jamPresets: [String]
  public let soloPresets: [String]
  public private(set) var isSoloMode = false
  public private(set) var presetIndex = 0
  public var prompt: String
  public var chaos = 0.48
  public var volume = 0.72
  public var noteStrength = 0.78
  public var styleStrength = 0.54

  public init(
    jamPresets: [String] = Self.defaultJamPresets,
    soloPresets: [String] = Self.defaultSoloPresets
  ) {
    self.jamPresets = jamPresets
    self.soloPresets = soloPresets
    prompt = jamPresets.first ?? ""
  }

  public var enginePrompt: String {
    isSoloMode ? "SOLO \(prompt)" : prompt
  }

  public mutating func setSoloMode(_ enabled: Bool) {
    guard isSoloMode != enabled else { return }
    isSoloMode = enabled
    presetIndex = 0
    prompt = activePresets.first ?? ""
  }

  public mutating func nextPreset() {
    navigate(by: 1)
  }

  public mutating func previousPreset() {
    navigate(by: -1)
  }

  private var activePresets: [String] {
    isSoloMode ? soloPresets : jamPresets
  }

  private mutating func navigate(by offset: Int) {
    guard !activePresets.isEmpty else {
      presetIndex = 0
      prompt = ""
      return
    }
    presetIndex = (presetIndex + offset + activePresets.count) % activePresets.count
    prompt = activePresets[presetIndex]
  }

  public static let defaultJamPresets = [
    "bluegrass banjo",
    "lo-fi hip hop",
    "drum and bass",
    "dreamy ambient pads",
    "disco funk ensemble",
  ]

  public static let defaultSoloPresets = [
    "fingerpicked acoustic guitar",
    "grand piano",
    "warm analog lead",
    "muted jazz trumpet",
  ]
}

public enum StudioWorkspace: String, CaseIterable, Identifiable, Sendable {
  case mrt = "MRT2"
  case collider = "Collider"
  case jam = "Jam"

  public var id: String { rawValue }
}

public struct StudioSession: Equatable, Sendable {
  public var workspace: StudioWorkspace = .mrt
  public private(set) var isPlaying = false
  public private(set) var activeNotes: [Int] = []
  public var octaveOffset = 0

  public init() {}

  public mutating func togglePlayback() {
    isPlaying.toggle()
  }

  public mutating func noteOn(_ note: Int) {
    let clamped = min(127, max(0, note))
    guard !activeNotes.contains(clamped) else { return }
    activeNotes.append(clamped)
    activeNotes.sort()
  }

  public mutating func noteOff(_ note: Int) {
    activeNotes.removeAll { $0 == note }
  }
}

public enum Pitch {
  public static func frequency(forMIDINote note: Int) -> Double {
    440 * pow(2, Double(note - 69) / 12)
  }
}

public struct PromptRow: Equatable, Identifiable, Sendable {
  public let id: Int
  public var text: String
  public var weight: Double
  public var colorIndex: Int

  public init(id: Int, text: String, weight: Double, colorIndex: Int) {
    self.id = id
    self.text = text
    self.weight = weight
    self.colorIndex = colorIndex
  }
}
