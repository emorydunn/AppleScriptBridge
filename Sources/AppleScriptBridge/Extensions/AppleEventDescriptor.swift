//
//  NSAppleEventDescriptor.swift
//  App
//
//  Created by Emory Dunn on 20 February, 2019.
//

import Foundation

extension NSAppleEventDescriptor {

	/// Creates and initializes a descriptor with a `missing value`.
	///
	/// The integer value is pulled from a returned descriptor `msng`
	///
	/// - Returns: A descriptor with `missing value`.
	public static func missingValue() -> NSAppleEventDescriptor {
		return NSAppleEventDescriptor(typeCode: 1836281447)
	}

	/// Initializes a newly allocated instance as a list descriptor with the specified descriptors.
	/// - Parameter list: Array of `NSAppleEventDescriptor` to add
	public convenience init(list: [NSAppleEventDescriptor]) {
		/// Create a new empty list
		self.init(listDescriptor: ())

		// Add the URLs to the list
		list.enumerated().forEach { index, descriptor in
			insert(descriptor, at: index + 1)
		}
	}

	/// Initializes a newly allocated instance as a list descriptor with the specified files.
	/// - Parameter fileList: Files to add to the list
	public convenience init(fileList list: [URL]) {
		self.init(list: list.map { NSAppleEventDescriptor(fileURL: $0) })
	}

	/// Initializes a newly allocated instance as a list descriptor with the specified file paths.
	/// - Parameter fileList: Files to add to the list
	public convenience init(pathList list: [URL]) {
		self.init(list: list.map { NSAppleEventDescriptor(string: $0.path) })
	}

	/// Initializes a newly allocated instance as a list descriptor with the specified strings.
	/// - Parameter fileList: Files to add to the list
	public convenience init(stringList list: [String]) {
		self.init(list: list.map { NSAppleEventDescriptor(string: $0) })
	}

	/// Returns a boolean indicating whether the descriptor should be considered `nil`.
	///
	/// - Returns: `true` if the descriptor is either `.null()` or `.missingValue()`, `false` otherwise.
	public var isNil: Bool {
		self == .null() || self == .missingValue()
	}
}
