// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "MotifGrid",
  platforms: [
    .iOS(.v18),
  ],
  products: [
    .library(name: "MotifGridCore", targets: ["MotifGridCore"]),
  ],
  targets: [
    .target(
      name: "MotifGridCore",
      path: "Sources/MotifGridCore"
    ),
    .testTarget(
      name: "MotifGridCoreTests",
      dependencies: ["MotifGridCore"],
      path: "Tests/MotifGridCoreTests"
    ),
  ]
)
