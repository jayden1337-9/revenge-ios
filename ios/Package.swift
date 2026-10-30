// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RevengeIOSBridge",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "RevengeIOSBridge", targets: ["RevengeIOSBridge"])
    ],
    targets: [
        .target(name: "RevengeIOSBridge"),
        .testTarget(name: "RevengeIOSBridgeTests", dependencies: ["RevengeIOSBridge"])
    ]
)
