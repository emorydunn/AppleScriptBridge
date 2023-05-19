//
//  EncoderTests.swift
//  
//
//  Created by Emory Dunn on 5/16/23.
//

import XCTest
@testable import AppleScriptBridge

final class EncoderTests: XCTestCase {

	func testEncodeValue() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value = 42
		let descriptor = NSAppleEventDescriptor(int: value)

		XCTAssertNoThrow(try value.encode(to: encoder))

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)

	}

	func testEncodeNil() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value: Int? = nil
		let descriptor = NSAppleEventDescriptor.null()

		XCTAssertNoThrow(try value.encode(to: encoder))

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)
	}

	func testEncodeArray() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value = [2, 4, 8]
		let descriptor = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(int32: 2),
													   NSAppleEventDescriptor(int32: 4),
													   NSAppleEventDescriptor(int32: 8),
													  ])

		XCTAssertNoThrow(try value.encode(to: encoder))

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)
	}

	func testEncodeDict() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value = ["greeting": "Hello", "name": "Emory"]
		let record = NSAppleEventDescriptor(list: [
			NSAppleEventDescriptor(string: "name"),
			NSAppleEventDescriptor(string: "Emory"),
			NSAppleEventDescriptor(string: "greeting"),
			NSAppleEventDescriptor(string: "Hello"),

		])

		let descriptor = NSAppleEventDescriptor.record()

		descriptor.setDescriptor(record, forKeyword: usrf)

		XCTAssertNoThrow(try value.encode(to: encoder))

		// - TODO: Figure out stable equality
//		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)
	}

	func testStructEncode() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value = GreetPerson()
		let descriptor = value.descriptor

		XCTAssertNoThrow(try value.encode(to: encoder))

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)
	}

	func testNestedStructEncode() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)

		let value = NestedRecord()
		let descriptor = value.descriptor

		XCTAssertNoThrow(try value.encode(to: encoder))

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)

	}

	func testEnumEncode() throws {
		let encoder = DescriptorEncoding(nilEncoding: .null)
		let descriptor = NSAppleEventDescriptor(string: "goodbye")

		try Greeting.goodbye.encode(to: encoder)

		XCTAssertEqual(descriptor, encoder.wrapper.descriptor)
	}
}

