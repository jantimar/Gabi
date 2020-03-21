//
//  XmlParser.swift
//  Gabi
//
//  Created by Jan Timar on 08/02/2020.
//

import Foundation

/// Internal XML parser for parser document directly after initialization
final class GabiParser: NSObject {
	private let parser: XMLParser
	private var node: XML?
	private var parentNode: XML?

	private var completition: ((Result<XML, Error>) -> Void)?

	init(
		data: Data,
		completition: @escaping (Result<XML, Error>) -> Void
	) {
		self.parser = XMLParser(data: data)
		self.completition = completition
		super.init()
		self.parser.delegate = self
		self.parser.parse()
	}
}

// MARK: - XMLParserDelegate

extension GabiParser: XMLParserDelegate {
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String: String] = [:]
	) {
		let node = XML(
			name: elementName,
			attributes: attributeDict
		)									// Create current parsing node
		node.parentNode = self.node			// Set parrent ndoe to current parsing node
		self.node?.nodes.append(node)		// Update child nodes
		self.node = node					// Update current parsing node

		// Set parent node if needed
		if parentNode == nil {				// Set current node as parent node it is first node
			parentNode = node
		}
	}

	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?) {
		node = node?.parentNode				// Set current parsing node as last know parrent node
	}

	func parser(
		_ parser: XMLParser,
		foundCharacters string: String
	) {
		// Update the node value
		// `stringByAppendingString(string)` don't work in some case
		node?.value =  "\(node?.value ?? "")\(string)"
	}

	func parser(
		_: XMLParser,
		parseErrorOccurred error: Error
	) {
		completition?(.failure(error))
		completition = nil
	}

	func parserDidEndDocument(_: XMLParser) {
		guard let node = parentNode else { return }
		completition?(.success(node))
		completition = nil
	}
}
