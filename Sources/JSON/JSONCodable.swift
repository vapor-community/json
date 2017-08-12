import Foundation

// MARK: protocols

public protocol JSONDecodable: Decodable {
    static func jsonKeyMap(key: CodingKey) -> CodingKey
}
public protocol JSONEncodable: Encodable {}

public typealias JSONCodable = JSONDecodable & JSONEncodable

extension JSONDecodable {
    public init(json: Data) throws {
        let decoder = try JSONDecoder<Self>(data: json)
        try self.init(from: decoder)
    }

    public static func jsonKeyMap(key: CodingKey) -> CodingKey {
        return key
    }
}


extension Array: JSONCodable {
    public static func jsonKeyMap(key: CodingKey) -> CodingKey {
        if let type = Element.self as? JSONCodable.Type {
            return type.jsonKeyMap(key: key)
        } else {
            return key
        }
    }
}

extension Dictionary: JSONCodable {
    public static func jsonKeyMap(key: CodingKey) -> CodingKey {
        if let type = Value.self as? JSONCodable.Type {
            return type.jsonKeyMap(key: key)
        } else {
            return key
        }
    }
}
