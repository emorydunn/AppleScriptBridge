//
//  Shared.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation
import Carbon

let usrf = AEKeyword(keyASUserRecordFields)

class DescriptorWrapper {
	var descriptor: NSAppleEventDescriptor = NSAppleEventDescriptor()

	init(descriptor: NSAppleEventDescriptor = NSAppleEventDescriptor()) {
		self.descriptor = descriptor
	}
}

struct IndexedCodingKey: CodingKey {
	let intValue: Int?
	var stringValue: String { String(intValue!) }

	init?(intValue: Int) { fatalError() }
	init?(stringValue: String) { fatalError() }

	init(_ index: Int) {
		intValue = index
	}
}
