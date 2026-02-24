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
		let outputPath = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources").appending(path: "Secrets.swift")
		var arguments: [String] = ["--output", outputPath.path()]
		let files = try FileManager.default.contentsOfDirectory(at: context.package.directoryURL, includingPropertiesForKeys: nil)

		let inputFiles = files.filter { url in
			url.lastPathComponent.hasPrefix(".env")
		}

		for file in inputFiles {
			arguments.append("--input")
			arguments.append(file.path())
		}

		return try [
			.buildCommand(
				displayName: "Generating Secrets from .env",
				executable: context.tool(named: "SecretsGenerator").url,
				arguments: arguments,
				inputFiles: inputFiles,
				outputFiles: [
					outputPath
				]
			)
		]
	}
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SecretsGeneratorPlugin: XcodeBuildToolPlugin {

	func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
		let outputPath = context.pluginWorkDirectoryURL.appending(path: "GeneratedSources").appending(path: "Secrets.swift")
		var arguments: [String] = ["--output", outputPath.path()]
		let files = try FileManager.default.contentsOfDirectory(at: context.xcodeProject.directoryURL, includingPropertiesForKeys: nil)

		let inputFiles = files.filter { url in
			url.lastPathComponent.hasPrefix(".env")
		}

		for file in inputFiles {
			arguments.append("--input")
			arguments.append(file.path())
		}

		return try [
			.buildCommand(displayName: "Generate Secrets from .env",
						  executable: context.tool(named: "SecretsGenerator").url,
						  arguments: arguments,
						  environment: [:],
						  inputFiles: inputFiles,
						  outputFiles: [outputPath])
		]
	}
}
#endif
