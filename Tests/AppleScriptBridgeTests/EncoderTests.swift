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
		let encoder = DescriptorEncoding()

		let value = 42

		try value.encode(to: encoder)

		print(encoder.wrapper.descriptor)
	}

	func testEncodeNil() throws {
		let encoder = DescriptorEncoding()

		let value: Int? = nil

		try value.encode(to: encoder)

		print(encoder.wrapper.descriptor)
	}

	func testEncodeArray() throws {
		let encoder = DescriptorEncoding()

		let value = [2, 4, 8]

		try value.encode(to: encoder)

		print(encoder.wrapper.descriptor)
	}

	func testStructEncode() throws {
		let encoder = DescriptorEncoding()

		struct Record: Codable {
			var value = 42

			var greeting = "Hello"
		}

		try Record().encode(to: encoder)

		print(encoder.wrapper.descriptor)
	}

	func testNestedStructEncode() throws {
		let encoder = DescriptorEncoding()

		struct Greet: Codable {
			var greeting = "Hello"

			var name = "Emory"

		}

		struct Record: Codable {
			var value = [2, 4, 8]

			var nested = Greet()
		}

		try Record().encode(to: encoder)

		print(encoder.wrapper.descriptor)

	}

	func testEnumEncode() throws {
		enum Greeting: String, Codable {
			case hello, goodbye
		}

		let encoder = DescriptorEncoding()

		try Greeting.goodbye.encode(to: encoder)

		print(encoder.wrapper.descriptor)
	}
}

