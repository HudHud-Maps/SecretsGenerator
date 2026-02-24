//
//  Engine.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation
import Stencil

public struct Engine {

	struct File {
		let name: String
		let secrets: [Secret]
	}

	public init() {}

	public func run(inputs: [URL], output: URL) throws {
		var context: [String: Any] = [:]
		var files: [File] = []

		for input in inputs {
			if input.lastPathComponent == ".env" {
				let secrets = try Dotenv().parse(url: input).map {
					return Secret(name: $0.key.toCamelCase(), value: $0.value)
				}
				context["secrets"] = secrets
			} else {
				var name = input.lastPathComponent
				name.trimPrefix(".env.")

				let secrets = try Dotenv().parse(url: input).map {
					return Secret(name: $0.key.toCamelCase(), value: $0.value)
				}

				files.append(File(name: name, secrets: secrets))
			}
		}
		context["files"] = files

		let rendered = try generateCode(from: context)

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

public enum Secrets {
 {% for secret in secrets %}
	public static let {{ secret.key }}: String = Secrets._xored({{ secret.secret }}, salt: {{ secret.salt}})
 {% endfor %}

{% for file in files %}
#if {{ file.name|uppercase }}
	{% for secret in file.secrets %}
	public static let {{ secret.key }}: String = Secrets._xored({{ secret.secret }}, salt: {{ secret.salt}})
	{% endfor %}
#endif
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
