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

	init(descriptor: DescriptorWrapper = DescriptorWrapper()) {
		codingPath = []
		userInfo = [:]
		self.wrapper = descriptor
	}

	func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
		print("Creating keyed container")

		let container = DescriptorKeyedEncoding<Key>(wrapper)
		container.codingPath = codingPath
		return KeyedEncodingContainer(container)
	}

	func unkeyedContainer() -> UnkeyedEncodingContainer {
		let container = DescriptorUnkeyedEncoding(wrapper)
		container.codingPath = codingPath
		return container
	}

	func singleValueContainer() -> SingleValueEncodingContainer {
		let container = DescriptorSingleValueEncoding(wrapper)
		container.codingPath = codingPath
		return container
	}

}
