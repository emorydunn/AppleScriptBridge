//
//  DecoderTests.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import XCTest
@testable import AppleScriptBridge

final class DecoderTests: XCTestCase {

	func testDecodeValue() throws {

		let descriptor = NSAppleEventDescriptor(int32: 42)
		let decoder = DescriptorDecoding(descriptor: descriptor)

		let value = try Int(from: decoder)

		XCTAssertEqual(42, value)
	}

	func testDecodeNil() throws {
		let descriptor = NSAppleEventDescriptor.null()
		let decoder = DescriptorDecoding(descriptor: descriptor)

		let value: Int? = try Optional<Int>(from: decoder)

		XCTAssertNil(value)
	}

	func testDecodeArray() throws {

		let descriptor = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(int32: 2),
													   NSAppleEventDescriptor(int32: 4),
													   NSAppleEventDescriptor(int32: 8),
													  ])
		let decoder = DescriptorDecoding(descriptor: descriptor)

		let value = try Array<Int>(from: decoder)

		XCTAssertEqual([2, 4, 8], value)
	}

	func testDecodeDict() throws {
		let record = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(string: "greeting"),
												   NSAppleEventDescriptor(string: "Hello"),
												   NSAppleEventDescriptor(string: "name"),
												   NSAppleEventDescriptor(string: "Emory")
												  ])

		let descriptor = NSAppleEventDescriptor.record()

		descriptor.setDescriptor(record, forKeyword: usrf)

		let decoder = DescriptorDecoding(descriptor: descriptor)

		let value = try Dictionary<String, String>(from: decoder)

		XCTAssertEqual(["greeting": "Hello", "name": "Emory"], value)
	}

	func testStruct() throws {

		struct Record: Codable {
			var greeting = "Hello"
			var name = "Emory"
		}

		let record = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(string: "greeting"),
												   NSAppleEventDescriptor(string: "Hello"),
												   NSAppleEventDescriptor(string: "name"),
												   NSAppleEventDescriptor(string: "Emory")
												  ])

		let descriptor = NSAppleEventDescriptor.record()

		descriptor.setDescriptor(record, forKeyword: usrf)

		let decoder = DescriptorDecoding(descriptor: descriptor)

		let value = try Record(from: decoder)

		print(value)


	}

}
