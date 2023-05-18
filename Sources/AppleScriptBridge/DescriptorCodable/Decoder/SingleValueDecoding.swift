//
//  SingleValueDecoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

struct SingleValueDecoding: SingleValueDecodingContainer {

	var codingPath: [CodingKey]

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper, codingPath: [CodingKey]) {
		// Use the encoder's wrapper and update the value
		self.wrapper = wrapper
		self.codingPath = codingPath
	}

	func decodeNil() -> Bool {
		wrapper.descriptor == NSAppleEventDescriptor.null()
	}

	func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		let decoder = DescriptorDecoding(wrapper)

		return try T.init(from: decoder)
	}

	func decode<T>(_ type: T.Type) throws -> T where T : Decodable, T: AppleEventDescriptorRepresentable {
		// Read the descriptor to the value's descriptor
		guard let value = T.init(from: wrapper.descriptor) else {
			let context = DecodingError.Context(codingPath: codingPath,
												debugDescription: "Expected \(T.self) but encountered descriptor with type \(wrapper.descriptor.eventDescriptorType).")
			throw DecodingError.valueNotFound(T.self, context)
		}

		return value
	}

	func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T : Decodable, T: AppleEventDescriptorRepresentable {
		// Read the descriptor to the value's descriptor
		return T.init(from: wrapper.descriptor)
	}
}
