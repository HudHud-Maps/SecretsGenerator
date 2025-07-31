// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SecretsGenerator",
	platforms: [.macOS(.v13)],
	products: [
		.plugin(name: "SecretsGeneratorPlugin", targets: ["SecretsGeneratorPlugin"])
	],
    dependencies: [
		.package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/lukepistrol/SwiftLintPlugin", from: "0.59.1"),
        .package(url: "https://github.com/DimaRU/PackageBuildInfo", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "SecretsGenerator",
            dependencies: [
				.target(name: "SecretsGeneratorFramework")
            ],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin"),
                .plugin(name: "PackageBuildInfoPlugin", package: "PackageBuildInfo")
            ]
        ),
		.target(
			name: "SecretsGeneratorFramework",
			dependencies: [
				.product(name: "Stencil", package: "Stencil"),
				.product(name: "ArgumentParser", package: "swift-argument-parser")
			],
            plugins: [
                .plugin(name: "SwiftLint", package: "SwiftLintPlugin")
            ]
		),
        .plugin(
            name: "SecretsGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [
                .byName(name: "SecretsGenerator")
            ])
    ]
)
