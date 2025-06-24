// swift-tools-version:6.0

import PackageDescription

var package = Package(
    name: "Merge",
    platforms: [
        .iOS(.v13),
        .macOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Merge",
            targets: [
                "CommandLineToolSupport",
                "ShellScripting",
                "SwiftDI",
                "Merge"
            ]
        )
    ],
    // Assuming you have updated the URLs to your mirrors
    dependencies: [
        .package(url: "https://github.com/isanf-terra/mirror-swallow.git", branch: "main"),
        .package(url: "https://github.com/isanf-terra/mirror-subproces.git", branch: "main"),
        .package(url: "https://github.com/isanf-terra/mirror-swiftuix.git", branch: "main")
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
                .product(name: "SwiftUIX", package: "mirror-swiftuix"),
                "SwiftDI"
            ],
            path: "Sources/Merge",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport"),
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "ShellScripting",
            dependencies: [
                "Merge",
                // Corrected: Specify the correct package name for the Subprocess product
                .product(name: "Subprocess", package: "mirror-subproces")
            ],
            path: "Sources/ShellScripting",
            swiftSettings: [
                .enableExperimentalFeature("AccessLevelOnImport"),
                .swiftLanguageMode(.v5),
            ]
        ),
        .target(
            name: "CommandLineToolSupport",
            dependencies: [
                "Merge",
                "ShellScripting",
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
                "ShellScripting",
            ],
            path: "Tests",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
