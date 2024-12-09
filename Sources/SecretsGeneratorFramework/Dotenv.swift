//
//  Dotenv.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation

public enum DotenvError: Error {
	case notFound
	case invalidValue
}

public struct Dotenv {
	private let fileManager: FileManager

	public init(fileManager: FileManager = .default) {
		self.fileManager = fileManager
	}

	public func parse(url: URL = URL(fileURLWithPath: ".env")) throws -> [String: String] {
		guard self.fileManager.fileExists(atPath: url.path) else {
			throw DotenvError.notFound
		}

		let contents = try String(contentsOf: url, encoding: .utf8)
		let lines = contents.split(separator: "\n").map {
			$0.trimmingCharacters(in: .whitespaces)
		}
		let filteredLines = lines.filter {
			$0.isEmpty == false && $0.starts(with: "#") == false
		}
		let elements = try filteredLines.map {
			let parts = $0
				.replacingOccurrences(of: "export", with: "")
				.split(separator: "=", maxSplits: 1)
			if parts.count != 2 {
				throw DotenvError.invalidValue
			}

			let key = parts[0].trimmingCharacters(in: .whitespaces)
			let value = parts[1]
				.trimmingCharacters(in: .whitespaces)
				.replacingOccurrences(of: "\"", with: "") // Remove quotes if any

			if key.rangeOfCharacter(from: .whitespaces) != nil {
				throw DotenvError.invalidValue
			}

			return Dictionary.Element(key: key, value: value)
		}

		return Dictionary(uniqueKeysWithValues: elements)
	}
}
