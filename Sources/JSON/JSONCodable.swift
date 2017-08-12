import Foundation

// MARK: protocols

public protocol JSONDecodable: Decodable {
    static func jsonKeyMap(key: CodingKey) -> String
}
public protocol JSONEncodable: Encodable {}

extension JSONDecodable {
    public init(json: Data) throws {
        let decoder = try JSONDecoder<Self>(data: json)
        try self.init(from: decoder)
    }

    public static func jsonKeyMap(key: CodingKey) -> String {
        return key.stringValue
    }
}

public typealias JSONCodeable = JSONDecodable & JSONEncodable

