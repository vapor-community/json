import Core
import Foundation

// MARK: protocols

public protocol JSONDecodable: Decodable {
    static func jsonKeyMap(key: CodingKey) -> CodingKey
}
public protocol JSONEncodable: Encodable {}

public typealias JSONCodable = JSONDecodable & JSONEncodable

extension JSONDecodable {
    public init(json data: Data) throws {
        var options: JSONSerialization.ReadingOptions = []
        options.insert(.allowFragments)
        let raw = try JSONSerialization.jsonObject(
            with: data,
            options: options
        )
        let json = JSONData(raw: raw)
        let decoder = PolymorphicDecoder<JSONData>(
            data: json,
            codingPath: [],
            codingKeyMap: Self.jsonKeyMap,
            userInfo: [
                .isJSON: true
            ]
        )
        try self.init(from: decoder)
    }

    public static func jsonKeyMap(key: CodingKey) -> CodingKey {
        return key
    }
}

extension CodingUserInfoKey {
    public static var isJSON: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "JSON")!
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
