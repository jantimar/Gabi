//
//  XML.swift
//  Gabi
//
//  Created by Jan Timar on 08/02/2020.
//

import Foundation

public final class XML {
	/// Xml node name
	public let name: String
	/// Xml attributes if any contain
	public let attributes: [String: String]
	/// Child nodes if any contain
	public var nodes = [XML]()
	/// Node value
	public var value: String?
	/// Element CDATA
	public var cData: String?
	/// Parent node, this reference must be weak to avoid retain cycles,
	/// when you dealloc some node, his childs will be automatically deallocated too
	public weak var parentNode: XML?

	public init(
		name: String,
		attributes: [String: String] = [:]
	) {
		self.name = name
		self.attributes = attributes
	}
}

extension XML: CustomStringConvertible {
	public var description: String {
		var prefix = ""
		var parentNode = self.parentNode
		while parentNode != nil {
			prefix.append("   ")
			parentNode = parentNode?.parentNode
		}


		return """

		\(prefix)Name:  		\(name)
		\(prefix)Attributes: 	\(attributes)
		\(prefix)Value: 		\(value?.replacingOccurrences(of: "\n", with: " ") ?? "-")
		\(prefix)Childs:
		\(prefix)\(nodes)

		"""
	}
}

extension XML: Sequence {
	/// Return all child nodes with specific `keys`
	public subscript(name: String) -> [XML] {
		return filter { $0.name == name }
	}

	/// Enable use `flatMap` `forEach` `map` ... on `Xml` to iterate child nodes
	__consuming public func makeIterator() -> XMLIterator {
		return XMLIterator(nodes: nodes)
	}

	/// Return first child with same `name`
	public func first(name: String) -> XML? {
		return first(where: { $0.name == name })
	}
}

public struct XMLIterator: IteratorProtocol {
	// MARK: - Private properties
	private var nodes: [XML]
	private var index = 0

	init(nodes: [XML]) {
		self.nodes = nodes
	}

	// MARK: - IteratorProtocol
	public typealias Element = XML

	public mutating func next() -> XML? {
		guard nodes.count > index else { return nil }
		let node = nodes[index]
        index += 1
        return node
	}
}
