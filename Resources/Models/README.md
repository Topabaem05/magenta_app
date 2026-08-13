# Model assets

Model binaries are intentionally excluded from Git. Install them beneath an app-managed model root using the paths in `model-assets.json`, then run:

```bash
python3 scripts/validate_model_assets.py \
  --manifest Resources/Models/model-assets.json \
  --root /path/to/MotifGridModels
```

The manifest pins the upstream MusicCoCa files and corrected iPhone Core ML weight payloads by SHA-256. Hash validation does not by itself enable production generation. MotifGrid also requires tokenizer, conditioning, tensor-schema, and sustained-runtime receipts. Each manifest entry must be a 64-character SHA-256 digest resolving to the exact shipping-build receipt; those entries are intentionally unset until measured.

Do not add `.tflite`, `.mlpackage`, `.mlmodelc`, `.safetensors`, `.mlxfn`, or model `.bin` files to Git.
