//
//  SecretsGenerator.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import ArgumentParser
import Foundation
import SecretsGeneratorFramework

@main
struct SecretsGenerator: ParsableCommand {

	public static let configuration = CommandConfiguration(
		abstract: "A utility tool for injecting secrets into Xcode projects",
        version: PackageBuild.info.describe
	)

	@Option(help: "The .env file used to generate the files.")
	var input: URL = URL(fileURLWithPath: ".env",
						 relativeTo: FileManager.default.currentDirectoryURL)

    @Option(help: "The .env.debug file used to generate the files.")
    var debug: URL?

	@Option(help: "Output url of the generated file.")
	var output: URL

	func run() throws {
        try Engine().run(input: self.input, debug: self.debug, output: self.output)
	}
}
