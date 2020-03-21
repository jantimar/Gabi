import XCTest
@testable import Gabi

final class GabiTests: XCTestCase {

	func testParseXML() {
		let xmlString = String.xml

		parse(xml: xmlString) { result in
			switch result {
			case let .success(xml):
				XCTAssertEqual(xml.name, "note") // Valid current node name
				XCTAssertEqual(xml.map { $0.name } , ["to", "from", "heading", "body"]) 	// Valid child names
				XCTAssertEqual(xml.first(name: "to")?.attributes["description"], "name") 	// Valid child attribute

			case let .failure(error):
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testParseXMLArray() {
		let xmlData = String.xmlArray.data(using: .utf8)!

		parse(xml: xmlData) { result in
			switch result {
			case let .success(xml):
				XCTAssertEqual(xml.nodes.count, 6) 		// Valid child nodes count
				XCTAssertEqual(xml["from"].count, 3) 	// Valid "from" child nodes count
				XCTAssertEqual(xml["from"].map { $0.name }, ["from", "from", "from"])	// Valid  "from" child nodes names
				XCTAssertEqual(xml["from"].map { $0.value }, ["Jan", "Jan2", "Jan3"])	// Valid  "from" child nodes values
				XCTAssertEqual(xml["heading"].first?["text"].first?.value, "Reminder")	// Valid  note -> first heading  -> first text -> value
			case let .failure(error):
				XCTFail(error.localizedDescription)
			}
		}
	}

	func testParseInvalidXML() {
		let xmlData = String.xmlInvalid.data(using: .utf8)!

		parse(xml: xmlData) { result in
			switch result {
			case .success:
				XCTFail("Expect `NSXMLParserError`")
			case let .failure(error):
				let nsError = error as NSError		// Valid expected Error for invalid XML
				XCTAssertEqual(nsError.domain, "NSXMLParserErrorDomain")
				XCTAssertEqual(nsError.code, 5)
			}
		}
	}

	static var allTests = [
        ("test_parse_xml", testParseXML),
        ("test_parse_array_xml", testParseXMLArray),
        ("test_parse_invalid_xml", testParseInvalidXML)
    ]
}

// MARK: - Helpers

private extension GabiTests {
	func parse(
		xml: Data,
		completition: @escaping (Result<XML, Error>) -> Void
	) {
		let expectation = XCTestExpectation(description: "\n⛔️ Load XML data")
		let xmlService = Gabi()

		xmlService.parse(xml: xml) { result in
			completition(result)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 2.0)
	}

	func parse(
		xml: String,
		completition: @escaping (Result<XML, Error>) -> Void
	) {
		let expectation = XCTestExpectation(description: "\n⛔️ Load XML string")
		let xmlService = Gabi()

		xmlService.parse(xml: xml) { result in
			completition(result)
			expectation.fulfill()
		}

		wait(for: [expectation], timeout: 2.0)
	}
}

// MARK: - Mocks

private extension String {
	static let xml = """
		<?xml version="1.0" encoding="UTF-8"?>
		<note>
			<to description="name">Zuzka</to>
			<from description='name'>Jan</from>
			<heading>Reminder</heading>
			<body>I need more chocletes!</body>
		</note>
		"""

	static let xmlArray = """
		<?xml version="1.0" encoding="UTF-8"?>
		<note>
			<to>Zuzka</to>
			<from>Jan</from>
			<from>Jan2</from>
			<from>Jan3</from>
			<heading><text>Reminder</text></heading>
			<body>I need more chocletes!</body>
		</note>
		"""

	// Note: Invalid XML because don't contain root node
	static let xmlInvalid = """
		<?xml version="1.0" encoding="UTF-8"?>
		<to description="name">Zuzka</to>
		<from description='name'>Jan</from>
		<from description='name'>Jan2</from>
		<from description='name'>Jan3</from>
		<heading>Reminder</heading>
		<body>I need more chocletes!</body>
		"""
}
