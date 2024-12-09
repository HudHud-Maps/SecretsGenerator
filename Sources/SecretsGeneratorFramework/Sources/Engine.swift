//
//  Engine.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation
import Stencil

public struct Engine {

	public init() {}

	public func run(input: URL, output: URL) throws {
		let dict = try Dotenv().parse(url: input)
		print(dict)

		let secrets = dict.map {
			return Secret(name: $0.key.toCamelCase(), value: $0.value)
		}

		let rendered = try generateCode(from: ["secrets": secrets])

		try rendered.write(to: output, atomically: true, encoding: .utf8)
	}
}

// MARK: - Private

private extension Engine {

	var template: String {
"""
// swiftlint:disable all
// Generated using SecretsGenerator - https://github.com/Patrick-Kladek/SecretsGenerator

import Foundation

enum Secrets {
	{% for secret in secrets %}
	static let {{ secret.key }}: String = Secrets._xored({{ secret.secret }}, salt: {{ secret.salt}})
	{% endfor %}
	private static func _xored(_ secret: [UInt8], salt: [UInt8]) -> String {
		return String(bytes: secret.enumerated().map { index, character in
			return character ^ salt[index % salt.count]
		}, encoding: .utf8) ?? ""
	}
}
"""
	}

	// Helper function to generate Swift code from a template and context
	func generateCode(from context: [String: Any]) throws -> String {
		let template = Template(templateString: self.template)
		return try template.render(context)
	}
}
