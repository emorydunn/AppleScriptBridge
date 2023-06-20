//
//  AppleScript Bridge.swift
//  Capturebot
//
//  Created by Emory Dunn on 2018-10-10.
//  Copyright © 2018 Emory Dunn. All rights reserved.
//

import Foundation
import Carbon

@available(*, deprecated, message: "Use NSAppleScript extensions.")
public class AppleScriptBridge {
	public static func checkPermissions(for application: String, askUserIfNeeded: Bool) {
		if #available(OSX 10.14, *) {
			NSLog("Checking AppleEvents permission")
			let descriptor = NSAppleEventDescriptor(string: application)

			let status = AEDeterminePermissionToAutomateTarget(
				descriptor.aeDesc!, typeWildCard, typeWildCard, askUserIfNeeded
			)

			NSLog("\(status)")
		}
	}

	@discardableResult
	/// Execute the AppleScript within the bundle for `AppleScriptBridge`
	/// - Parameters:
	///   - resource: The name of the resource.
	///   - fileExtension: The extension of the file.
	///   - scriptHandler: The handler to execute.
	///   - args: The arguments to pass to the handler.
	/// - Returns: The result of the handler.
	public static func executeAppleScript(forResource resource: String, withExtension fileExtension: String?, scriptHandler: String, args: [NSAppleEventDescriptor]) throws -> NSAppleEventDescriptor {

		guard let scriptFile = Bundle(for: AppleScriptBridge.self).url(forResource: resource, withExtension: fileExtension) else {
			throw ScriptError.couldNotLocateResource(called: resource)
		}

		return try NSAppleScript.script(contentsOf: scriptFile).execute(scriptHandler: scriptHandler, args: args)

	}

	// MARK: - ExpressibleByAppleEventDescriptor

}
