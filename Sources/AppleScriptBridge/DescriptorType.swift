//
//  DescriptorType.swift
//  
//
//  Created by Emory Dunn on 5/17/23.
//

import Foundation

public enum DescriptorType: UInt32, CustomStringConvertible {
	case int32 = 1819242087 // typeSInt32
	case string = 1970567284
	case char = 1413830740 // typeChar
	case list = 1818850164 // typeAEList
	case record = 1919247215 // typeAERecord
	case boolean = 1651470188 // typeBoolean
	case date = 1818522656
	case null = 1853189228 // typeNull
	case applicationURL = 1634759276 // typeApplicationURL
	case bundleIdentifier = 1651863140
	case double = 1685026146
	case fileURL = 1718973036 // typeFileURL
	case processIdentifier = 1802529124
	case missingValue = 1954115685

	case unknown = 0

	init(_ typeCode: DescType) {
		if let type = DescriptorType(rawValue: typeCode) {
			self = type
		} else {
			self = .unknown
		}
	}

	public var description: String {
		switch self {
		case .int32: return "int32"
		case .string: return "string"
		case .char: return "char"
		case .list: return "list"
		case .record: return "record"
		case .boolean: return "boolean"
		case .date: return "date"
		case .null: return "null"
		case .applicationURL: return "applicationURL"
		case .bundleIdentifier: return "bundleIdentifier"
		case .double: return "double"
		case .fileURL: return "fileURL"
		case .processIdentifier: return "processIdentifier"
		case .missingValue: return "missingValue"
		case .unknown: return "unknown"
			
		}
	}
}

public extension NSAppleEventDescriptor {
	var eventDescriptorType: DescriptorType {
		DescriptorType(descriptorType)
	}
}
