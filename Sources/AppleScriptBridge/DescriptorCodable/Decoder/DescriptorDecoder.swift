//
//  DescriptorDecoder.swift
//  
//
//  Created by Emory Dunn on 5/18/23.
//

import Foundation

/// An object that decodes instances of a data type from Apple Event Descriptors.
public class DescriptorDecoder {

	/// Creates a new, reusable Apple Event Descriptor decoder with the default formatting settings and encoding strategies.
	public init() { }


	/// Returns a value of the type you specify, decoded from an Apple Event Descriptor.
	/// - Parameters:
	///   - value: The type of the value to decode from the supplied Apple Event Descriptor.
	///   - descriptor: The Apple Event Descriptor to decode.
	/// - Returns: A value of the specified type, if the decoder can parse the data.
	public func decode<T: Decodable>(_ value: T.Type, from descriptor: NSAppleEventDescriptor) throws -> T {
		let decoder = DescriptorDecoding(descriptor: descriptor)

		return try T.init(from: decoder)
	}
}
