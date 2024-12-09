//
//  SecretsGeneratorPlugin.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation
import PackagePlugin

@main
struct SecretsGeneratorPlugin {}

// MARK: - BuildToolPlugin

extension SecretsGeneratorPlugin: BuildToolPlugin {
	func createBuildCommands(context: PluginContext, target _: Target) throws -> [Command] {
		let inputPath = context.package.directoryURL.appending(path: ".env")
		let outputPath = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources").appending(path: "Secrets.swift")

		return try [
			.buildCommand(
				displayName: "Generating Secrets from .env",
				executable: context.tool(named: "SecretsGenerator").url,
				arguments: ["--input", inputPath.path(), "--output", outputPath.path()]
			)
		]
	}
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SecretsGeneratorPlugin: XcodeBuildToolPlugin {

	func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
		let inputPath = context.xcodeProject.directoryURL.appending(path: ".env")
		let outputPath = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources").appending(path: "Secrets.swift")

		return try [
			.buildCommand(displayName: "Generate Secrets from .env",
						  executable: context.tool(named: "SecretsGenerator").url,
						  arguments: [
							"--input", inputPath.path, "--output", outputPath.path
						  ],
						  environment: [:],
						  inputFiles: [inputPath],
						  outputFiles: [outputPath])
		]
	}
}
#endif
