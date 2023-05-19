//
//  Test Objects.swift
//  
//
//  Created by Emory Dunn on 5/19/23.
//

import Foundation
@testable import AppleScriptBridge

enum Greeting: String, Codable, Equatable {
	case hello, goodbye
}

struct GreetPerson: Codable, Equatable {
	var greeting: Greeting

	var person: String

	init(greeting: Greeting = .hello, person: String = "Emory") {
		self.greeting = greeting
		self.person = person
	}

	var descriptor: NSAppleEventDescriptor {
		let record = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(string: "greeting"),
												   NSAppleEventDescriptor(string: greeting.rawValue),
												   NSAppleEventDescriptor(string: "person"),
												   NSAppleEventDescriptor(string: person)
												  ])

		let descriptor = NSAppleEventDescriptor.record()

		descriptor.setDescriptor(record, forKeyword: usrf)

		return descriptor
	}
}

struct NestedRecord: Codable, Equatable {
	var integer: Int

	var array: [String]

	var greeting: GreetPerson

	init(integer: Int = 42, array: [String] = ["lorem", "ipsum"], greeting: GreetPerson = GreetPerson()) {
		self.integer = integer
		self.array = array
		self.greeting = greeting
	}

	var descriptor: NSAppleEventDescriptor {
		let record = NSAppleEventDescriptor(list: [NSAppleEventDescriptor(string: "integer"),
												   NSAppleEventDescriptor(int: integer),
												   NSAppleEventDescriptor(string: "array"),
												   array.descriptor,
												   NSAppleEventDescriptor(string: "greeting"),
												   greeting.descriptor
												  ])

		let descriptor = NSAppleEventDescriptor.record()

		descriptor.setDescriptor(record, forKeyword: usrf)

		return descriptor
	}
}
