# Third-Party Notices

MotifGrid is an independent application. It is not affiliated with, endorsed by, or distributed by Google. Google, Magenta, and related names and marks remain the property of their respective owners.

## Magenta RealTime 2 source code

- Component: Google DeepMind Magenta RealTime 2 code and reference application logic
- Source: https://github.com/magenta/magenta-realtime
- License: Apache License 2.0
- Use in MotifGrid: protocol contracts, model integration research, and an independently implemented native piano interaction surface informed by the Apache-licensed Jam example
- Modifications: MotifGrid uses native Swift, SwiftUI, UIKit, AVFAudio, and Core ML integration rather than the upstream macOS React/AppKit host

Copyright 2026 Google LLC.

Licensed under the Apache License, Version 2.0. The complete text is bundled as `Resources/Licenses/Apache-2.0.txt`.

## Magenta RealTime 2 model assets

- Component: MusicCoCa, MRT2 Small, SpectroStream, and numerical-format derivatives
- Source: https://huggingface.co/google/magenta-realtime-2
- License: CC BY 4.0
- Attribution: “Magenta RealTime 2 by Google DeepMind”
- Use in MotifGrid: optional local model installation for fully on-device prompt encoding and music generation

The model weights are not stored in this repository. Their expected paths and SHA-256 digests are declared in `Resources/Models/model-assets.json`.

The complete CC BY 4.0 legal text is bundled as `Resources/Licenses/CC-BY-4.0.txt`.

## iPhone Core ML conversion research

- Component: corrected MRT2 Small Core ML conversion artifacts, exporters, tensor contracts, and validation methodology
- Source: https://github.com/mattmireles/magenta-realtime-2-iphone
- Code license: Apache License 2.0
- Converted weight license: CC BY 4.0
- Use in MotifGrid: expected corrected model package names, weight hashes, compute-unit boundaries, and fail-closed tensor-schema validation

MotifGrid does not claim that the upstream conversion project is an official Google iOS release.

## TensorFlow Lite

- Component: TensorFlow Lite Swift runtime
- Source: https://github.com/tensorflow/tensorflow
- License: Apache License 2.0
- Use in MotifGrid: fully local MusicCoCa text encoder and vector-quantizer execution

## SentencePiece

- Component: SentencePiece model format and reference tokenizer behavior
- Source: https://github.com/google/sentencepiece
- License: Apache License 2.0
- Use in MotifGrid: parsing the official `spm.model` and validating the pure-Swift unigram tokenizer against frozen reference fixtures

## Apple frameworks

MotifGrid uses system frameworks supplied with iOS and iPadOS, including SwiftUI, UIKit, AVFAudio, Core ML, Accelerate, Observation, Foundation, and OSLog. Their use is governed by the applicable Apple developer agreements and platform terms.
