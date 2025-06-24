// swift-tools-version:6.0

import PackageDescription

var package = Package(
    name: "Merge",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Merge",
            targets: [
                "CommandLineToolSupport",
                "SwiftDI",
                "Merge"
            ]
        )
    ],
    // Assuming you have updated the URLs to your mirrors
    dependencies: [
        // mirror-subproces dependency removed
        .package(url: "https://github.com/isanf-terra/mirror-swallow.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SwiftDI",
            dependencies: [
                // Corrected: Specify both product and package name
                .product(name: "Swallow", package: "mirror-swallow")
            ],
            path: "Sources/SwiftDI",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport"),
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "Merge",
            dependencies: [
                // Corrected: Specify both product and package name
                .product(name: "Swallow", package: "mirror-swallow"),
                .product(name: "SwallowMacrosClient", package: "mirror-swallow"),
                "SwiftDI"
            ],
            path: "Sources/Merge",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport"),
                .swiftLanguageMode(.v5),
            ]
        ),
        // ShellScripting target has been deleted.
        .target(
            name: "CommandLineToolSupport",
            dependencies: [
                "Merge",
                // "ShellScripting" dependency removed
                // Corrected: Specify both product and package name
                .product(name: "Swallow", package: "mirror-swallow"),
            ],
            path: "Sources/CommandLineToolSupport",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport"),
                .swiftLanguageMode(.v5),
            ]
        ),
        .testTarget(
            name: "MergeTests",
            dependencies: [
                "CommandLineToolSupport",
                "Merge",
                // "ShellScripting" dependency removed
            ],
            path: "Tests",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
