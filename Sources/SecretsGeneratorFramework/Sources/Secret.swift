//
//  Secret.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation

struct Secret {
	let key: String
	let secret: String
	let salt: String

	init(name: String, value: String) {
		let salt = [UInt8].random(length: 64)
		let secret = "\(Self.xorEncode(secret: value, salt: salt))"

		self.key = name
		self.secret = secret
		self.salt = "\(salt)"
	}
}

// MARK: - Private

private extension Secret {

	static func xorEncode(secret: String, salt: [UInt8]) -> [UInt8] {
		let secretBytes = [UInt8](secret.utf8)
		return secretBytes.enumerated().map { index, character in
			return character ^ salt[index % salt.count]
		}
	}
}
