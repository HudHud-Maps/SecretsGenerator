//
//  FileManagerExtension.swift
//  SecretsGenerator
//
//  Created by Patrick Kladek on 09.12.24.
//

import Foundation

public extension FileManager {

	var currentDirectoryURL: URL {
		return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	}
}
