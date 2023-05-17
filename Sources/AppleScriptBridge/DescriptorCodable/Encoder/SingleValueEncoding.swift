//
//  SingleValueEncoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

class DescriptorSingleValueEncoding: SingleValueEncodingContainer {
	var codingPath: [CodingKey] = []

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper) {
		// Use the encoder's wrapper and update the value
		self.wrapper = wrapper
	}

	func encodeNil() throws {
		// Set the descriptor to null
		wrapper.descriptor = .null()
	}

	func encode<T>(_ value: T) throws where T : Encodable {
		// Create a new encoder for the value
		let encoder = DescriptorEncoding()
		encoder.codingPath = codingPath

		// Encode the value
		try value.encode(to: encoder)

		// Set the descriptor to the encoded result
		wrapper.descriptor = encoder.wrapper.descriptor
	}

	func encode<T>(_ value: T) throws where T : Encodable, T: AppleEventDescriptorRepresentable {
		// Set the descriptor to the value's descriptor
		wrapper.descriptor = value.descriptor
	}

}
