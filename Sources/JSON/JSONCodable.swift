public typealias JSONCodable = JSONDecodable & JSONEncodable

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

extension CodingUserInfoKey {
    public static var isJSON: CodingUserInfoKey {
        return CodingUserInfoKey(rawValue: "JSON")!
    }
}
