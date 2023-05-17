//
//  KeyedEncoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

class DescriptorKeyedEncoding<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {

	var codingPath: [CodingKey] = []

	var currentIndex = 1

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper) {
		// Replace the encoder's wrapper with a record descriptor and container
		wrapper.descriptor = NSAppleEventDescriptor(recordDescriptor: ())
		wrapper.descriptor.setDescriptor(NSAppleEventDescriptor(listDescriptor: ()), forKeyword: usrf)

		self.wrapper = wrapper
	}

	func encodeDescriptor(_ descriptor: NSAppleEventDescriptor, forKey key: Key) {
		// Get the record's container
		let record = wrapper.descriptor.forKeyword(usrf)!

		// Insert the key and value
		record.insert(key.stringValue.descriptor, at: currentIndex) // Key
		record.insert(descriptor, at: currentIndex + 1) // Value

		// Update the record's container
		wrapper.descriptor.setDescriptor(record, forKeyword: usrf)

		// Increment the count for both key and value
		currentIndex += 2
	}

	func encodeNil(forKey key: Key) throws {
		// Add the null to the record
		encodeDescriptor(.null(), forKey: key)
	}

	func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
		// Create a new encoder for the value
		let encoder = DescriptorEncoding()
		encoder.codingPath.append(key)

		// Encode the value
		try value.encode(to: encoder)

		// Add the encoded result to the record
		encodeDescriptor(encoder.wrapper.descriptor, forKey: key)

	}

	func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable, T: AppleEventDescriptorRepresentable {
		// Add the value's descriptor to the record
		encodeDescriptor(value.descriptor, forKey: key)
	}

	func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError(#function)
	}

	func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		fatalError(#function)
	}

	func superEncoder() -> Encoder {
		fatalError(#function)
	}

	func superEncoder(forKey key: Key) -> Encoder {
		fatalError(#function)
	}

}
