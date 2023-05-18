//
//  ExpressibleByAppleEventDescriptor.swift
//
//
//  Created by Emory Dunn on 2/15/22.
//

import Foundation
import Carbon

public protocol AppleEventDescriptorRepresentable {
	var descriptor: NSAppleEventDescriptor { get }

	init?(from descriptor: NSAppleEventDescriptor)
}

extension String: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(string: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		guard let value = descriptor.stringValue else {
			return nil
		}
		self = value
	}
}

extension Date: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(date: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		guard let value = descriptor.dateValue else {
			return nil
		}
		self = value
	}
}

extension Bool: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(boolean: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {

		// Handle default `false`
		guard descriptor.eventDescriptorType == .boolean else { return nil }

		self = descriptor.booleanValue
	}
}

extension Double: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(double: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		// Handle default `0.0`
		guard descriptor.eventDescriptorType == .double else { return nil }
		self = descriptor.doubleValue
	}
}

extension URL: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(fileURL: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		guard let value = descriptor.fileURLValue else {
			return nil
		}
		self = value
	}
}

extension Int: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(int32: Int32(self))
	}

	/// Instantiate an integer from a descriptor.
	/// - Parameter descriptor: The descriptor.
	/// - Note: This will return a value of `0` even in the case when the event does not actually contain an integer value.
	public init?(from descriptor: NSAppleEventDescriptor) {
		// Handle default `0`
		guard descriptor.eventDescriptorType == .int32 else { return nil }

		self = Int(descriptor.int32Value)
	}
}

extension Array: AppleEventDescriptorRepresentable where Element: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(list: descriptors)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {

		guard descriptor.eventDescriptorType == .list else { return nil }

		self.init(descriptorOrEmpty: descriptor)

	}

	public init(descriptorOrEmpty descriptor: NSAppleEventDescriptor) {

		guard descriptor.numberOfItems > 0 else {
			self = []
			return
		}

		self = (1...descriptor.numberOfItems).compactMap { index in
			guard let item = descriptor.atIndex(index) else { return nil }
			return Element(from: item)
		}
	}

	var descriptors: [NSAppleEventDescriptor] {
		self.map { $0.descriptor }
	}
}

extension Optional: AppleEventDescriptorRepresentable where Wrapped: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		guard let value = self else {
			return NSAppleEventDescriptor.missingValue()
		}

		return value.descriptor
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		self = Wrapped.init(from: descriptor)
	}
}

extension RawRepresentable where RawValue: AppleEventDescriptorRepresentable {
	public var descriptor: NSAppleEventDescriptor {
		rawValue.descriptor
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		guard let raw = RawValue.init(from: descriptor) else { return nil }
		self.init(rawValue: raw)
	}
}

