import Core
import Foundation

public protocol JSONDecodable: Decodable {
    static func jsonKeyMap(key: CodingKey) -> CodingKey
}

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
