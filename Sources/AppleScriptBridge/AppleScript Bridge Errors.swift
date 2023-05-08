//
//  AppleScript Bridge Errors.swift
//  CaptureOne
//
//  Created by Emory Dunn on 2019-02-21.
//

import Foundation


public enum ScriptError: LocalizedError, CustomStringConvertible {
	case couldNotLocateResource(called: String)
	case couldNotLoadScript(at: URL, error: NSDictionary)
	case couldNotExecute(method: String?, args: [NSAppleEventDescriptor], script: String, error: String, number: Int?)
	case couldNotCompileSource(source: String)
	case executionError(error: String, number: Int?, source: String)

	public var errorDescription: String? {
		switch self {
		case let .couldNotExecute(_, _, _, error, _):
			return error
		case .couldNotLoadScript:
			return "Error Loading Script"
		case .couldNotLocateResource:
			return "Error Locating Resource"
		case .couldNotCompileSource:
			return "The AppleScript source could not be compiled"
		case .executionError(let error, _, _):
			return error
		}
	}

	public var failureReason: String? {
		switch self {
		case let .couldNotExecute(method, args, _, _, _):
			if let method = method {
				return "Error Executing handler '\(method)' with \(args)"
			}
			return "Error Executing Script"
		case let .couldNotLoadScript(url, error):
			return "The script \(url.lastPathComponent) could not be loaded: \(error)"
		case .couldNotLocateResource(let name):
			return "Could not locate bundle resource called \(name)"
		case .couldNotCompileSource:
			return "The AppleScript source could not be compiled"
		case .executionError:
			return "The script returned an error"
		}
	}

	public var description: String {
  """
  \(errorDescription ?? "No error description given")
  \(failureReason ?? "No failure reason specified")
  \(recoverySuggestion ?? "No suggested recovery")
  """
	}

}

public enum ResultError: LocalizedError, CustomStringConvertible {
	
	case resultWasNil(method: String)
	case unexpectedType(method: String, expected: String)

	public var description: String {
   """
   \(errorDescription ?? "No error description given")
   \(failureReason ?? "No failure reason specified")
   \(recoverySuggestion ?? "No suggested recovery")
   """
	}
}
