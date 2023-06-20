//
//  DescriptorEncoder.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

/// An object that encodes instances of a data type as Apple Event Descriptors.
public class DescriptorEncoder {

	/// Creates a new, reusable Apple Event Descriptor encoder with the default formatting settings and encoding strategies.
	public init() { }

	/// A value that determines how to encode `nil` in the AppleEvent Descriptor.
	public var nilEncoding: NilEncodingStrategy = .null

	/// Returns an Apple Event Descriptor representation of the value you supply.
	/// - Parameter value: The value to encode as an Apple Event Descriptor.
	/// - Returns: The Apple Event Descriptor.
	public func encode<T: Encodable>(_ value: T) throws -> NSAppleEventDescriptor {
		let encoder = DescriptorEncoding(nilEncoding: nilEncoding)

		try value.encode(to: encoder)

		return encoder.wrapper.descriptor
	}
}

extension DescriptorEncoder {
	/// The values that determine how to encode `nil` in an AppleEvent Descriptor.
	public enum NilEncodingStrategy {
		/// Encode `nil` values as `null`.
		case null

		/// Encode `nil` values as `missingValue`.
		case missingValue

		var descriptor: NSAppleEventDescriptor {
			switch self {
			case .null:
				return .null()
			case .missingValue:
				return .missingValue()
			}
		}
	}
}
