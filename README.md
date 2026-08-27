# MotifGrid

MotifGrid is a native SwiftUI iOS/iPadOS prototype inspired by the interaction patterns in
[Magenta RealTime 2](https://magenta.withgoogle.com/mrt2#apps-plugins). It recreates the three
reference workspaces supplied for this project—MRT2, Collider, and Jam—in a buildable app.

## Current prototype

- MRT2 prompt mixer with editable prompts, strength controls, memory-bank controls, transport,
  and a playable keyboard.
- Collider with draggable prompt nodes and listener; blend weights use normalized inverse-square
  distance, matching the open-source MRT2 example.
- Jam with Solo/Jam modes, wrapping prompt presets, strength controls, transport, and keyboard.
- Deterministic local oscillator audio so the prototype is interactive without model weights.
- Shared Swift package tests for prompt blending, preset navigation, transport, and MIDI pitch.

The app is deliberately labeled **LOCAL DEMO**. Google's MRT2 runtime currently targets Apple
Silicon Macs through JAX/MLX/C++; the large model weights and a production iOS inference engine are
not bundled here. `StudioModel` and `LocalSynthesizer` keep the UI and playback boundary explicit so
an iOS-compatible generator can replace the demo backend later.

## Build locally

Requirements: Xcode with the iOS 18 SDK and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
brew install xcodegen
xcodegen generate
open MotifGrid.xcodeproj
```

Select the `MotifGrid` scheme and a landscape iPhone or iPad simulator, then Build & Run.

## Verify

```bash
swift test
python3 -m unittest discover -s tests -p 'test_*.py' -v
python3 scripts/check_scaffold.py
python3 scripts/check_repository.py
```

GitHub Actions runs the portable tests on Linux and generates/builds the iOS project on macOS.

## Xcode Cloud

1. Open the generated project in Xcode and sign in to the Apple Developer account.
2. Set the MotifGrid target's Team and confirm the bundle identifier is available.
3. Choose **Product → Xcode Cloud → Create Workflow**.
4. Connect `Topabaem05/magenta_app`, select the `MotifGrid` scheme, and use `main` (or this feature
   branch while testing) as the start condition.
5. Keep `ci_scripts/ci_post_clone.sh`; Xcode Cloud runs it after checkout to install XcodeGen,
   generate the project, and validate the repository.
6. Add TestFlight distribution to the Archive action after App Store Connect has an app record.

Recommended workflow: pull request changes run Build + Test; pushes to `main` run Build + Test +
Archive; tagged releases distribute the archive to TestFlight.

## Reference and licensing

The UI was reconstructed from supplied screenshots using the layout-analysis approach described by
[screenshot-to-code](https://github.com/abi/screenshot-to-code), then implemented natively in
SwiftUI. The project does not copy its generated web stack.

Magenta reference logic comes from
[magenta/magenta-realtime](https://github.com/magenta/magenta-realtime). See
`THIRD_PARTY_NOTICES.md` for attribution. MotifGrid is independent and is not affiliated with or
endorsed by Google.
