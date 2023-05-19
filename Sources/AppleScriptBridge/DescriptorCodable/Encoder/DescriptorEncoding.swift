//
//  DescriptorEncoding.swift
//  
//
//  Created by Emory Dunn on 5/16/23.
//

import Foundation

class DescriptorEncoding: Encoder {
	var codingPath: [CodingKey]

	var userInfo: [CodingUserInfoKey : Any]

	var wrapper: DescriptorWrapper

	var nilEncoding: DescriptorEncoder.NilEncodingStrategy

	init(descriptor: DescriptorWrapper = DescriptorWrapper(), nilEncoding: DescriptorEncoder.NilEncodingStrategy) {
		codingPath = []
		userInfo = [:]
		self.wrapper = descriptor
		self.nilEncoding = nilEncoding
	}

	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		let container = DescriptorKeyedEncoding<Key>(wrapper, nilEncoding: nilEncoding)
		container.codingPath = codingPath
		return KeyedEncodingContainer(container)
	}

	func unkeyedContainer() -> UnkeyedEncodingContainer {
		let container = DescriptorUnkeyedEncoding(wrapper, nilEncoding: nilEncoding)
		container.codingPath = codingPath
		return container
	}

	func singleValueContainer() -> SingleValueEncodingContainer {
		let container = DescriptorSingleValueEncoding(wrapper, nilEncoding: nilEncoding)
		container.codingPath = codingPath
		return container
	}

}
