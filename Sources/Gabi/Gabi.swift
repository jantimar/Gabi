import Foundation

public enum GabiError: Error {
	/// Throw when `XML` String can not be parsed to `Data` with `utf8` formatting
	case invalidXMLString
}

/// XmlService for parse `XML`Data to `Xml`
final public class Gabi {
	/// Parse `XML` data to `XML` object
	/// - Parameters:
	///   - xml: `XML` data, usually xml string  in .utf8 format in `Data`
	///   - completition: Completion block is call when finish reading whole document, it is call on background queue
	public func parse(
		xml data: Data,
		completition: @escaping (Result<XML, Error>) -> Void
	) {
		DispatchQueue
			.global(qos: .default)
			.async { [weak self] in
				self?.parser = GabiParser(
					data: data,
					completition: completition
				)
		}
	}

	/// Parse `XML` string to `XML` object
	/// - Parameters:
	///   - string: `Xml` raw string
	///   - completition: Completion block is call when finish reading whole document, it is call on background queue
	public func parse(
		xml string: String,
		completition: @escaping (Result<XML, Error>) -> Void
	) {
		guard let data = string.data(using: .utf8) else {
			completition(.failure(GabiError.invalidXMLString))
			return
		}
		parse(xml: data, completition: completition)
	}

	// MARK: - Private properties

	private var parser: GabiParser?
	private lazy var uuid = UUID()
}

// MARK: - Equatable

extension Gabi: Equatable {
	public static func == (lhs: Gabi, rhs: Gabi) -> Bool {
		lhs.uuid == rhs.uuid
	}
}
