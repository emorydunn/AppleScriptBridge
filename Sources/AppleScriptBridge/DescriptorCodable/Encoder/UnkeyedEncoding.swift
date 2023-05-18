//
//  UnkeyedEncoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

class DescriptorUnkeyedEncoding: UnkeyedEncodingContainer {

	var codingPath: [CodingKey] = []

	var count: Int = 1

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper) {
		// Replace the encoder's wrapper with a list descriptor
		wrapper.descriptor = NSAppleEventDescriptor(listDescriptor: ())

		self.wrapper = wrapper
	}

	func insertValue(_ value: NSAppleEventDescriptor) {
		wrapper.descriptor.insert(value, at: count)
		count += 1
	}

	func encodeNil() throws {
		// Add null to the list
		insertValue(.null())
	}

	func encode<T>(_ value: T) throws where T : Encodable {
		// Create a new encoder for the value
		let encoder = DescriptorEncoding()
		encoder.codingPath = codingPath + [IndexedCodingKey(count)]

		// Encode the value
		try value.encode(to: encoder)

		// Add the encoded result to the list
		insertValue(encoder.wrapper.descriptor)
	}
	
	func encode<T>(_ value: T) throws where T : Encodable, T: AppleEventDescriptorRepresentable {
		// Add the value's descriptor to the list
		insertValue(value.descriptor)
	}

	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError(#function)
	}

	func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		fatalError(#function)
	}

	func superEncoder() -> Encoder {
		fatalError(#function)
	}


}
