//
//  ExpressibleByAppleEventDescriptor.swift
//
//
//  Created by Emory Dunn on 2/15/22.
//

import Foundation
import Carbon

/// A type that can be converted to and from an associated Apple Event Descriptor.
public protocol AppleEventDescriptorRepresentable {

	static var descriptorType: DescriptorType { get }

	var descriptor: NSAppleEventDescriptor { get }

	init?(from descriptor: NSAppleEventDescriptor)
}

extension String: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .string

	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(string: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {

		guard Self.descriptorMatchesType(descriptor) else { return nil }

		guard let value = descriptor.stringValue else {
			return nil
		}
		self = value
	}
}

extension Date: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .date

	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(date: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {

		// Handle default reference date
		guard Self.descriptorMatchesType(descriptor) else { return nil }

		guard let value = descriptor.dateValue else {
			return nil
		}
		self = value
	}
}

extension Bool: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .boolean

	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(boolean: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		// Handle default `false`
		switch descriptor.eventDescriptorType {
		case .boolean, .true, .false:
			self = descriptor.booleanValue
		default:
			return nil
		}
	}
}

extension Double: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .double


	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(double: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		// Handle default `0.0` or cast from Int
		switch descriptor.eventDescriptorType {
		case .double:
			self = descriptor.doubleValue
		case .int32:
			self = Double(descriptor.int32Value)
		default:
			return nil
		}
	}
}

extension URL: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .fileURL

	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(fileURL: self)
	}

	public init?(from descriptor: NSAppleEventDescriptor) {

		// Attempt to decode as a fileURL
		if Self.descriptorMatchesType(descriptor),
			let value = descriptor.fileURLValue {
			self = value
		} else if let value = descriptor.stringValue {
			// Attempt to decode from a string path
			self = URL(fileURLWithPath: value)
		} else {
			return nil
		}
	}
}

extension Int: AppleEventDescriptorType {

	public static var descriptorType: DescriptorType = .int32

	public var descriptor: NSAppleEventDescriptor {
		NSAppleEventDescriptor(int32: Int32(self))
	}

	/// Instantiate an integer from a descriptor.
	/// - Parameter descriptor: The descriptor.
	/// - Note: This will return a value of `0` even in the case when the event does not actually contain an integer value.
	public init?(from descriptor: NSAppleEventDescriptor) {
		// Handle default `0` or cast from double
		// Handle default `0.0` or cast from Int
		switch descriptor.eventDescriptorType {
		case .int32:
			self = Int(descriptor.int32Value)
		case .double:
		self = Int(descriptor.doubleValue)
		default:
			return nil
		}
	}
}

extension Array: AppleEventDescriptorRepresentable where Element: AppleEventDescriptorRepresentable {

	public static var descriptorType: DescriptorType { .list }

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

extension Data: AppleEventDescriptorRepresentable {

	public static var descriptorType: DescriptorType { .unknown }

	public init?(from descriptor: NSAppleEventDescriptor) {
		self = descriptor.data
	}

	public var descriptor: NSAppleEventDescriptor {
		fatalError("This method is not implemented")
	}
}


extension Optional: AppleEventDescriptorRepresentable where Wrapped: AppleEventDescriptorRepresentable {

	public static var descriptorType: DescriptorType { Wrapped.descriptorType }

	public var descriptor: NSAppleEventDescriptor {
		guard let value = self else {
			return NSAppleEventDescriptor.missingValue()
		}

		return value.descriptor
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		if let value = Wrapped.init(from: descriptor) {
			self = .some(value)
		} else {
			return nil
		}
	}
}

extension RawRepresentable where RawValue: AppleEventDescriptorRepresentable {

	public static var descriptorType: DescriptorType { RawValue.descriptorType }

	public var descriptor: NSAppleEventDescriptor {
		rawValue.descriptor
	}

	public init?(from descriptor: NSAppleEventDescriptor) {
		guard let raw = RawValue.init(from: descriptor) else { return nil }
		self.init(rawValue: raw)
	}
}

