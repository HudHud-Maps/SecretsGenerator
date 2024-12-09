//
//  ArrayExtension.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import Foundation

extension Array where Element == UInt8 {
	static func random(length: Int) -> [UInt8] {
		return (0...length).map { _ in UInt8.random(in: UInt8.min...UInt8.max) }
	}
}
