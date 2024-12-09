//
//  URLExtension.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 08.12.24.
//

import ArgumentParser
import Foundation

extension URL: @retroactive ExpressibleByArgument {

	public init?(argument: String) {
		self.init(fileURLWithPath: argument)
	}
}
