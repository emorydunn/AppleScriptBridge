//
//  DescriptorEncoder.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

public class DescriptorEncoder {
	public init() { }

	public func encode<T: Encodable>(_ value: T) throws -> NSAppleEventDescriptor {
		let encoder = DescriptorEncoding()

		try value.encode(to: encoder)

		return encoder.wrapper.descriptor
	}
}
