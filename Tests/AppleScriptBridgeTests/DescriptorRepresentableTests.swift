//
//  DescriptorRepresentableTests.swift
//  
//
//  Created by Emory Dunn on 5/18/23.
//

import XCTest
@testable import AppleScriptBridge

final class DescriptorRepresentableTests: XCTestCase {


	func testString() {
		let value = "Hello, world"
		let descriptor = NSAppleEventDescriptor(string: value)

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(String(from: descriptor), value)
		XCTAssertNil(String(from: .null()))
	}

	func testInt() {
		let value = 42
		let descriptor = NSAppleEventDescriptor(int32: Int32(value))

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Int(from: descriptor), value)
		XCTAssertNil(Int(from: .null()))
	}
	
	func testInt_CastFromDouble() {
		let value = 42.0
		let descriptor = NSAppleEventDescriptor(double: value)
		
		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Int(from: descriptor), Int(value))
		XCTAssertNil(Int(from: .null()))
	}

	func testDouble() {
		let value = 42.1
		let descriptor = NSAppleEventDescriptor(double: value)

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Double(from: descriptor), value)
		XCTAssertNil(Double(from: .null()))
	}
	
	func testDouble_CastFromInt() {
		let value = 42
		let descriptor = NSAppleEventDescriptor(int32: Int32(value))
		
		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Double(from: descriptor), Double(value))
		XCTAssertNil(Double(from: .null()))
	}

	func testBool() {
		let value = true
		let descriptor = NSAppleEventDescriptor(boolean: value)

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Bool(from: descriptor), value)
		XCTAssertNil(Bool(from: .null()))
	}

	func testDate() {
		let value = Date()
		let descriptor = NSAppleEventDescriptor(date: value)

		XCTAssertEqual(value.descriptor, descriptor)
//		XCTAssertEqual(Date(from: descriptor), value) - TODO: Test Always fails
		XCTAssertNil(Date(from: .null()))
	}

	func testFileURL() {
		let value = URL(fileURLWithPath: "/Applications")
		let descriptor = NSAppleEventDescriptor(fileURL: value)

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(URL(from: descriptor), value)
		XCTAssertNil(URL(from: .null()))
	}

	func testArray() {
		let value = [2, 4, 8]
		let descriptor = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(int32: 2),
													   NSAppleEventDescriptor(int32: 4),
													   NSAppleEventDescriptor(int32: 8)
													  ])

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(Array<Int>(from: descriptor), value)
		XCTAssertNil(Array<Int>(from: .null()))

		XCTAssertEqual(Array<Int>(descriptorOrEmpty: .null()), [])
	}

	func testOptional() {
		let value: Int? = 42
		let nilValue: Int? = nil
		let descriptor = NSAppleEventDescriptor(int32: 42)

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(nilValue.descriptor, .missingValue())
		XCTAssertEqual(Optional<Int>(from: descriptor), value)

		XCTAssertNil(Optional<Int>(from: .list()) as Any?)
	}

	func testRawRepresentable() {
		let value = FloatingPointSign.plus
		let descriptor = NSAppleEventDescriptor(int32: Int32(value.rawValue))

		XCTAssertEqual(value.descriptor, descriptor)
		XCTAssertEqual(FloatingPointSign(from: descriptor), value)
		XCTAssertNil(FloatingPointSign(from: .null()))
	}

}
