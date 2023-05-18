//
//  KeyedDecoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

/// An object that acts as a proxy to look up CodingKeys in a record descriptor.
struct DescriptorProxy<Key: CodingKey> {

	/// All `CodingKeys` available in the record.
	let allKeys: [Key]

	/// <#Description#>
	let keyMapping: [String: NSAppleEventDescriptor]

	init(_ descriptor: NSAppleEventDescriptor) throws {
		guard let record = wrapper.descriptor.forKeyword(usrf) else {
			let context = DecodingError.Context(codingPath: codingPath, debugDescription: "AppleEvent does not contain a top-level `usfr` keyword.")
			throw DecodingError.dataCorrupted(context)
		}

		// Reduce the keys into a `[KeyName: ValueIndex]`
		self.keyMapping = stride(from: 1, through: record.numberOfItems, by: 2).reduce(into: [String: NSAppleEventDescriptor]()) { partialResult, index in
			let key = record.atIndex(index)!
			let value = record.atIndex(index + 1)
			partialResult[key.stringValue!] = value
		}

		self.allKeys = keyMapping.keys.sorted().compactMap {
			Key(stringValue: $0)
		}

	}

	subscript (_ key: Key) -> NSAppleEventDescriptor? {
		keyMapping[key.stringValue]
	}

}

class KeyedDecoding<Key>: KeyedDecodingContainerProtocol where Key: CodingKey {

	var allKeys: [Key] { recordProxy.allKeys }

	var codingPath: [CodingKey]

	var recordProxy: DescriptorProxy<Key>

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper, codingPath: [CodingKey]) throws {
		// Use the encoder's wrapper and update the value
		self.wrapper = wrapper
		self.codingPath = codingPath

		self.recordProxy = try DescriptorProxy<Key>(wrapper.descriptor)

	}

	func decodeDescriptor(_ descriptor: NSAppleEventDescriptor, forKey key: Key) throws -> NSAppleEventDescriptor {

		guard let value = recordProxy[key] else {
			let context = DecodingError.Context(codingPath: codingPath, debugDescription: "AppleEvent does not have a value for key \(key.stringValue)")
			throw DecodingError.keyNotFound(key, context)
		}

		return value

	}


	func contains(_ key: Key) -> Bool {
		recordProxy.keyMapping.keys.contains(key.stringValue)
	}

	func decodeNil(forKey key: Key) throws -> Bool {
		try decodeDescriptor(wrapper.descriptor, forKey: key) == .null()
	}


	func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {

		let descriptor = try decodeDescriptor(wrapper.descriptor, forKey: key)

		let decoder = DescriptorDecoding(descriptor: descriptor)

		return try T.init(from: decoder)
	}

	func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable, T: AppleEventDescriptorRepresentable {
		let descriptor = try decodeDescriptor(wrapper.descriptor, forKey: key)

		guard let value = T.init(from: descriptor) else {
			let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Expected \(T.self) but encountered descriptor with type \(wrapper.descriptor.eventDescriptorType).")
			throw DecodingError.valueNotFound(T.self, context)
		}

		return value
	}

	func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
		fatalError(#function)
	}

	func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
		fatalError(#function)
	}

	func superDecoder() throws -> Decoder {
		fatalError(#function)
	}

	func superDecoder(forKey key: Key) throws -> Decoder {
		fatalError(#function)
	}

}
