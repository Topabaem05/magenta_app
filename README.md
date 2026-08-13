# MotifGrid

MotifGrid is a native iOS and iPadOS music studio for fully on-device, text-guided instrumental music generation. Its interaction model combines a compact GarageBand/Logic-style timeline with a chat-like prompt composer, a playable multi-touch piano, and an adaptive launchpad.

The product name and bundle identifier are independent from Google and Magenta:

- Product: `MotifGrid`
- Bundle identifier: `com.topabaem.motifgrid`
- Platforms: iOS/iPadOS 18 or later
- Language/UI: Swift 6, SwiftUI, and a narrow UIKit bridge for the low-latency piano surface

## Implemented studio surface

- HIG-oriented adaptive navigation for iPhone and iPad.
- Track creation, selection, removal, mute, and solo.
- Timeline playback with region start times, track gain/pan, looping, and transport controls.
- Chat-like prompt history and multiline text input.
- Prompt generation with optional take recording and automatic timeline-region insertion.
- Native multi-touch MIDI piano with slide/glissando handling.
- Keyboard/Pads instrument carousel.
- Memory-, width-, thermal-, and voice-aware `2×2`, `3×3`, or `4×4` launchpad pages.
- Sixteen persistent pad assignments; smaller grids expose the remaining cells through accessible paging rather than hiding them.
- Atomic CAF take recording and local project persistence under Application Support.
- Deterministic, explicitly non-Magenta demo synthesis for end-to-end UI, audio, recording, track, and launchpad development.
- App-local model status, privacy disclosure, attribution, and third-party notices.

## On-device model boundary

The production design is entirely local:

1. Pure-Swift SentencePiece tokenization.
2. MusicCoCa `text_encoder.tflite` execution.
3. MusicCoCa vector quantization.
4. Certified MusicCoCa-to-MRT2 conditioning projection.
5. Corrected MRT2 Small Core ML temporal, depth, and SpectroStream stages.
6. CPU RVQ gather, inverse STFT/overlap-add, and AVAudioEngine delivery.

No prompt or generated audio is sent to an inference server. App source validation rejects `URLSession`, `NWConnection`, and `Network`-framework inference paths.

### Production gates

The repository deliberately does **not** fabricate the two missing certified runtime components:

- a parity-validated on-device MusicCoCa-to-MRT2 conditioning projector;
- the complete corrected host-owned-cache frame loop, RVQ gather, inverse STFT, and sustained-device receipt for the exact shipping artifacts.

`MusicCoCaPromptEncoder` and `MRT2GeneratorAdapter` validate local assets, exact tensor contracts, and 64-character content-addressed receipt digests. Production mode activates only when every required model role and every certification receipt is present. Otherwise MotifGrid starts in clearly labeled local demo mode.

The production backend also refuses to start on an unrecognized device or on hardware with less than 6 GiB of physical memory. A supported A14-class device remains in Render mode until the sustained Live benchmark passes; the deterministic demo backend remains available independently of this production-model gate.

## Requirements

- macOS with Xcode supporting Swift 6
- XcodeGen
- Bundler and CocoaPods 1.16.2
- `TensorFlowLiteSwift ~> 2.17`
- `swift-format`

## Bootstrap on macOS

```bash
brew install xcodegen swift-format
bundle install
xcodegen generate
bundle exec pod install
open MotifGrid.xcworkspace
```

## Verification

Portable checks run on Linux or macOS:

```bash
make verify
```

Equivalent commands:

```bash
swift test
python3 -m unittest discover -s tests -p 'test_*.py' -v
swift-format lint --recursive --strict Sources Tests
python3 scripts/check_scaffold.py
python3 scripts/check_repository.py
```

Apple-only SwiftUI, AVFAudio, Core ML, and TensorFlow Lite sources are generated and built by the macOS GitHub Actions job. Model weights, generated Xcode projects, CocoaPods output, and build products are prohibited from source control.

## Model assets

See:

- `Resources/Models/README.md`
- `Resources/Models/model-assets.json`
- `docs/model-integration.md`
- `docs/device-qualification.md`

The manifest pins known upstream asset sizes and SHA-256 digests. Hash success alone is insufficient: tokenizer, conditioning, tensor-schema, and sustained-runtime receipts must also be valid 64-character digests and match the current shipping build.

## Licensing

- MotifGrid application code: proprietary by default; see `LICENSE`.
- Magenta RealTime 2 reference code: Apache License 2.0.
- Magenta RealTime 2 model weights and numerical derivatives: CC BY 4.0.
- TensorFlow Lite and SentencePiece: Apache License 2.0.

Complete attribution and modification notes are in `THIRD_PARTY_NOTICES.md`. MotifGrid is independent and is not affiliated with or endorsed by Google.
Full Apache 2.0 and CC BY 4.0 legal texts are bundled under `Resources/Licenses` and displayed inside the app information screen.
