//
//  UnkeyedDecoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

class UnkeyedDecoding: UnkeyedDecodingContainer {

	var count: Int? { wrapper.descriptor.numberOfItems }

	var isAtEnd: Bool { self.currentIndex >= self.count! }

	var currentIndex: Int = 0

	var codingPath: [CodingKey] = []

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper, codingPath: [CodingKey]) {
		// Use the encoder's wrapper and update the value
		self.wrapper = wrapper
		self.codingPath = codingPath
	}

	func decodeDescriptor() throws -> NSAppleEventDescriptor {
		guard let descriptor = wrapper.descriptor.atIndex(currentIndex + 1) else {
			let context = DecodingError.Context(codingPath: codingPath, debugDescription: "No descriptor found at index \(currentIndex)")
			throw DecodingError.keyNotFound(IndexedCodingKey(currentIndex), context)
		}

		currentIndex += 1
		return descriptor

	}

	func decodeNil() throws -> Bool {
		try decodeDescriptor() == NSAppleEventDescriptor.null()
	}

	func decode<T>(_ type: T.Type) throws -> T where T: AppleEventDescriptorRepresentable, T: Decodable {
		// - TODO: This doesn't seem to be called
		// Read the descriptor to the value's descriptor
		let descriptor = try decodeDescriptor()

		guard let value = T.init(from: descriptor) else {
			let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(T.self) but encountered descriptor with type \(wrapper.descriptor.eventDescriptorType).")
			throw DecodingError.valueNotFound(T.self, context)
		}

		return value
	}

	func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
		// - TODO: For types which are AppleEventDescriptorRepresentable don't construct a new decoder
		let descriptor = try decodeDescriptor()
		let decoder = DescriptorDecoding(descriptor: descriptor)
		
		return try T.init(from: decoder)
	}

	func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError(#function)
	}

	func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
		fatalError(#function)
	}

	func superDecoder() throws -> Decoder {
		fatalError(#function)
	}
}
