//
//  DescriptorDecoding.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

class DescriptorDecoding: Decoder {
	var codingPath: [CodingKey]

	var userInfo: [CodingUserInfoKey : Any]

	var wrapper: DescriptorWrapper

	init(_ wrapper: DescriptorWrapper = DescriptorWrapper()) {
		codingPath = []
		userInfo = [:]
		self.wrapper = wrapper
	}

	convenience init(descriptor: NSAppleEventDescriptor) {
		self.init(DescriptorWrapper(descriptor: descriptor))
	}

	func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
		let container = try KeyedDecoding<Key>(wrapper, codingPath: codingPath)
		return KeyedDecodingContainer(container)
	}

	func unkeyedContainer() throws -> UnkeyedDecodingContainer {
		return UnkeyedDecoding(wrapper, codingPath: codingPath)
	}

	func singleValueContainer() throws -> SingleValueDecodingContainer {
		return SingleValueDecoding(wrapper, codingPath: codingPath)
	}

}
