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

	@Option(help: "Output url of the generated file.")
	var output: URL

	func run() throws {
		try Engine().run(input: self.input, output: self.output)
	}
}

extension PackageBuild {

    var describe: String {
        guard self.digest.hasElements else {
            return "dirty"
        }

        guard let tag = self.tag else {
            return String(commit.prefix(8))
        }

        var desc = tag

        if countSinceTag != 0 {
            desc += "-\(countSinceTag)-g\(commit.prefix(7))"
        }

        if isDirty {
            desc += "-dirty"
        }

        return desc
    }
}
