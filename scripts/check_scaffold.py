#!/usr/bin/env python3
from pathlib import Path
import plistlib
import sys

ROOT = Path(__file__).resolve().parents[1]

required = [
    "project.yml",
    "Package.swift",
    "Config/Info.plist",
    "Sources/MotifGridCore/StudioEngine.swift",
    "Sources/MotifGridApp/MotifGridApp.swift",
    "Sources/MotifGridApp/Views/MRTWorkspaceView.swift",
    "Sources/MotifGridApp/Views/ColliderWorkspaceView.swift",
    "Sources/MotifGridApp/Views/JamWorkspaceView.swift",
    "ci_scripts/ci_post_clone.sh",
]

missing = [path for path in required if not (ROOT / path).is_file()]
if missing:
    print("Missing required files:", *missing, sep="\n- ")
    sys.exit(1)

with (ROOT / "Config/Info.plist").open("rb") as handle:
    info = plistlib.load(handle)

orientations = info.get("UISupportedInterfaceOrientations", [])
if "UIInterfaceOrientationLandscapeLeft" not in orientations:
    print("MotifGrid must support its reference landscape layout")
    sys.exit(1)

print("Scaffold validation passed")
