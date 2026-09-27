// swift-tools-version: 5.9
import PackageDescription

// Lets the app build and run without Xcode: `swift build`, `swift run`, `swift test`.
// The Xcode project (project.yml / .xcodeproj) remains the canonical build for
// producing a signed, notarized .app bundle; this package targets the same sources.
let package = Package(
    name: "ClaudeUsageSystray",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "ClaudeUsageSystray",
            path: "Sources"
        ),
        .testTarget(
            name: "ClaudeUsageSystrayTests",
            dependencies: ["ClaudeUsageSystray"],
            path: "Tests"
        ),
    ]
)
