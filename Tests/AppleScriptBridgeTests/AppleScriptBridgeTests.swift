import XCTest
@testable import AppleScriptBridge

final class AppleScriptBridgeTests: XCTestCase {

	// MARK: - Convenience Wrappers
	func testExecuteThrows() {
		guard let script = NSAppleScript(source: "return 42") else {
			XCTFail()
			return
		}

		XCTAssertNoThrow(try script.execute())
	}

	func testExecuteThrowsError() {

		guard let script = NSAppleScript(source: "error number 42") else {
			XCTFail()
			return
		}

		XCTAssertThrowsError(try script.execute())

	}

	func testCallHander() {
		let source = """
		on runTest()
		return 42
		end runTest
		"""

		guard let script = NSAppleScript(source: source) else {
			XCTFail()
			return
		}

		XCTAssertNoThrow(try script.execute(scriptHandler: "runTest", args: [.null()]))

	}

	// MARK: - Representable Methods

	func testExecuteReturnOptional() throws {
		guard let script = NSAppleScript(source: "return 42") else {
			XCTFail()
			return
		}

		let result: Int? = try script.execute()

		XCTAssertEqual(result, 42)
	}

	func testExecuteReturnType() throws {
		guard let script = NSAppleScript(source: "return 42") else {
			XCTFail()
			return
		}

		XCTAssertEqual(try script.executeThrowingOnNil(), 42)
	}

	func testExecuteReturnOptionalType() {
		guard let script = NSAppleScript(source: "return null") else {
			XCTFail()
			return
		}

		do {
			let result: String = try script.executeThrowingOnNil()
			XCTFail("Should have thrown an error, not \(result)")
		} catch {

		}
	}

	
}

