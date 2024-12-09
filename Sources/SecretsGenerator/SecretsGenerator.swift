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
		version: "0.1.0"
	)

	@Option(help: "The .env file used to generate the files.")
	var input: URL = URL(fileURLWithPath: ".env",
						 relativeTo: FileManager.default.currentDirectoryURL)

	@Option(help: "Output url of the generated file.")
	var output: URL

	func run() throws {
		try Engine().run(input: self.input, output: self.output)
	}
}
