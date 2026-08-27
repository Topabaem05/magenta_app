#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
forbidden_directories = ["Pods", "MotifGrid.xcodeproj", "MotifGrid.xcworkspace", ".build"]
present = [name for name in forbidden_directories if (ROOT / name).exists()]
if present:
    print("Generated directories must not be committed:", ", ".join(present))
    sys.exit(1)

swift_sources = list((ROOT / "Sources").rglob("*.swift"))
for source in swift_sources:
    text = source.read_text(encoding="utf-8")
    if "URLSession" in text or "import Network" in text:
        print(f"Unexpected network inference path in {source.relative_to(ROOT)}")
        sys.exit(1)

print("Repository validation passed")
