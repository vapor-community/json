import Core
import Foundation

extension JSON {
    /// Serialize JSON with something that can
    /// be represented as bytes, for example,
    /// 'Data'
    public init(
        bytes: BytesRepresentable,
        allowFragments: Bool = true
    ) throws {
        let bytes = try bytes.makeBytes()
        try self.init(bytes: bytes, allowFragments: allowFragments)
    }

    /// Serialize JSON with the bytes representing
    /// the JSON data
    public init(
        bytes: Bytes,
        allowFragments: Bool
    ) throws {
        let options: JSONSerialization.ReadingOptions
        if allowFragments {
            options = .allowFragments
        } else {
            options = .init(rawValue: 0)
        }

        let data = Data(bytes: bytes)
        let json = try JSONSerialization.jsonObject(
            with: data,
            options: options
        )

        try self.init(foundationJSON: json)
    }
}

extension JSON {
    /// Attempt to initialize a node with a foundation object.
    ///
    /// - parameter any: the object to create a node from
    /// - throws: if fails to create node.
    internal init(foundationJSON: Any) throws {
        switch foundationJSON {
            // If we're coming from foundation, it will be an `NSNumber`.
        //This represents double, integer, and boolean.
        case let number as Double:
            // When coming from ObjC Any, this will represent all Integer types and boolean
            self = .double(number)
        // Here to catch 'Any' type, but MUST come AFTER 'Double' check for JSON fuzziness
        case let bool as Bool:
            self = .bool(bool)
        case let int as Int:
            self = .int(int)
        case let string as String:
            self = .string(string)
        case let object as [String : Any]:
            var mutable: [String: JSON] = [:]
            try object.forEach { key, val in
                mutable[key] = try JSON(foundationJSON: val)
            }
            self = .object(mutable)
        case let array as [Any]:
            self = try .array(array.map(JSON.init))
        case _ as NSNull:
            self = .null
        case let data as Data:
            self = .string(data.makeString())
        case let bytes as NSData:
            var raw = Bytes(repeating: 0, count: bytes.length)
            bytes.getBytes(&raw, length: bytes.length)
            self = .string(raw.makeString())
        case let date as Date:
            self = .double(date.timeIntervalSince1970)
        case let date as NSDate:
            let date = Date(timeIntervalSince1970: date.timeIntervalSince1970)
            self = .double(date.timeIntervalSince1970)
        default:
            self = .null
        }
    }

    /// Creates a FoundationJSON representation of the
    /// data for serialization w/ JSONSerialization
    internal var foundationJSON: Any {
        switch self {
        case .array(let values):
            return values.map { $0.foundationJSON }
        case .bool(let value):
            return value
        case .null:
            return NSNull()
        case .int(let int):
            return int
        case .double(let double):
            return double
        case .object(let values):
            var dictionary: [String: Any] = [:]
            for (key, value) in values {
                dictionary[key] = value.foundationJSON
            }
            return dictionary
        case .string(let value):
            return value
        }
    }
}
