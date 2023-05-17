//
//  File.swift
//  
//
//  Created by Emory Dunn on 3/25/23.
//

import Foundation
import Carbon

extension NSAppleScript {

	/// Creates a script from the contents of a file.
	/// - Parameter url: The URL of an AppleScript
	/// - Returns: An `NSAppleScript` compiled from the contents of the file. 
	public static func script(contentsOf url: URL) throws -> NSAppleScript {
		var error: NSDictionary?

		guard let script = NSAppleScript(contentsOf: url, error: &error) else {
			throw ScriptError.couldNotLoadScript(at: url, error: error ?? [:])
		}

		return script
	}


	@discardableResult
	/// Execute the specified AppleScript.
	/// - Parameter script: The script to execute.
	/// - Returns: The result of the script.
	public func execute() throws -> NSAppleEventDescriptor {
		var error: NSDictionary?

		// Run the script
		let result = executeAndReturnError(&error)

		if let error = error {
			throw ScriptError.couldNotExecute(
				method: nil,
				args: [],
				script: source ?? "Script has no source code available",
				error: error[NSAppleScript.errorMessage] as? String ?? "No error message provided",
				number: error[NSAppleScript.errorNumber] as? Int
			)
		}

		return result
	}

	@discardableResult
	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func execute(scriptHandler: String, args: [NSAppleEventDescriptor]) throws -> NSAppleEventDescriptor {
		// Add positional arguments
		// Modified from https://gist.github.com/chbeer/3666e4b7b2e71eb47b15eaae63d4192f

		let parameters = NSAppleEventDescriptor(list: args)

		var psn = ProcessSerialNumber(highLongOfPSN: UInt32(0), lowLongOfPSN: UInt32(kCurrentProcess))
		let target = NSAppleEventDescriptor(descriptorType: DescType(typeProcessSerialNumber), bytes:&psn, length:MemoryLayout<ProcessSerialNumber>.size)
		let handler = NSAppleEventDescriptor(string: scriptHandler)

		let event = NSAppleEventDescriptor.appleEvent(withEventClass: AEEventClass(kASAppleScriptSuite),
													  eventID: AEEventID(kASSubroutineEvent),
													  targetDescriptor: target,
													  returnID: AEReturnID(kAutoGenerateReturnID),
													  transactionID: AETransactionID(kAnyTransactionID))

		event.setParam(handler, forKeyword: AEKeyword(keyASSubroutineName))
		event.setParam(parameters, forKeyword: AEKeyword(keyDirectObject))

		// Run the script
		return try execute()
	}

	// MARK: - ExpressibleByAppleEventDescriptor
	/// Execute the specified AppleScript.
	/// - Parameter script: The script to execute.
	/// - Returns: The result of the script.
	public func execute<D: AppleEventDescriptorRepresentable>() throws -> D? {
		D.init(from: try execute())
	}

	/// Execute the specified AppleScript.
	/// - Parameter script: The script to execute.
	/// - Returns: The result of the script.
	public func executeThrowingOnNil<D: AppleEventDescriptorRepresentable>() throws -> D {
		guard let value = D.init(from: try execute()) else {
			throw ResultError.resultWasNil(method: "")
		}

		return value
	}


	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func execute(scriptHandler: String, args: [AppleEventDescriptorRepresentable] = []) throws {
		try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor))
	}

	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func execute(scriptHandler: String, args: AppleEventDescriptorRepresentable...) throws {
		try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor))
	}

	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func execute<D: AppleEventDescriptorRepresentable>(scriptHandler: String, args: [AppleEventDescriptorRepresentable] = []) throws -> D? {
		D.init(from: try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor)))
	}


	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func execute<D: AppleEventDescriptorRepresentable>(scriptHandler: String, args: AppleEventDescriptorRepresentable...) throws -> D? {
		D.init(from: try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor)))
	}

	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func executeThrowingOnNil<D: AppleEventDescriptorRepresentable>(scriptHandler: String, args: [AppleEventDescriptorRepresentable] = []) throws -> D {
		guard let value = D.init(from: try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor))) else {
			throw ResultError.resultWasNil(method: scriptHandler)
		}
		return value
	}

	/// Execute the specified handler in the specified AppleScript.
	/// - Parameters:
	///   - url: The AppleScript.
	///   - scriptHandler: The AppleScript handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public func executeThrowingOnNil<D: AppleEventDescriptorRepresentable>(scriptHandler: String, args: AppleEventDescriptorRepresentable...) throws -> D {
		guard let value = D.init(from: try execute(scriptHandler: scriptHandler, args: args.map(\.descriptor))) else {
			throw ResultError.resultWasNil(method: scriptHandler)
		}
		return value
	}

}
