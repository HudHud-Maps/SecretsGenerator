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

    public func run(input: URL, debug: URL?, output: URL) throws {
        var context: [String: Any] = [:]
        let secrets = try Dotenv().parse(url: input).map {
			return Secret(name: $0.key.toCamelCase(), value: $0.value)
		}
        context["secrets"] = secrets

        if let debug {
            let secretsDebug = try Dotenv().parse(url: debug).map {
                return Secret(name: $0.key.toCamelCase(), value: $0.value)
            }
            context["debug"] = secretsDebug
        }

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
#if DEBUG
    {% for secret in debug %}
    public static let {{ secret.key }}: String = Secrets._xored({{ secret.secret }}, salt: {{ secret.salt}})
    {% endfor %}
#endif
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
