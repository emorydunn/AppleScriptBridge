//
//  DescriptorDecoder.swift
//  
//
//  Created by Emory Dunn on 5/18/23.
//

import Foundation

public class DescriptorDecoder {
	public init() { }

	public func decode<T: Decodable>(_ value: T, from descriptor: NSAppleEventDescriptor) throws -> T {
		let decoder = DescriptorDecoding(descriptor: descriptor)

		return try T.init(from: decoder)
	}
}
