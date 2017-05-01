import Core
import Foundation

extension JSON {
    /// Serialize JSON with something that can
    /// be represented as bytes, for example,
    /// 'Data'
    public init(
        bytes: BytesRepresentable,
        allowFragments: Bool = false
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
        let structuredData = try StructuredData(json: json)
        self = JSON(structuredData)
    }
}

extension StructuredData {
    /// Attempt to initialize a node with a foundation object.
    ///
    /// - parameter any: the object to create a node from
    /// - throws: if fails to create node.
    public init(json: Any) throws {
        switch json {
            // If we're coming from foundation, it will be an `NSNumber`.
        //This represents double, integer, and boolean.
        case let number as Double:
            // When coming from ObjC Any, this will represent all Integer types and boolean
            self = .number(Number(number))
        // Here to catch 'Any' type, but MUST come AFTER 'Double' check for JSON fuzziness
        case let bool as Bool:
            self = .bool(bool)
        case let int as Int:
            self = .number(Number(int))
        case let uint as UInt:
            self = .number(Number(uint))
        case let string as String:
            self = .string(string)
        case let object as [String : Any]:
            self = try StructuredData(json: object)
        case let array as [Any]:
            self = try .array(array.map(StructuredData.init))
        case _ as NSNull:
            self = .null
        case let data as Data:
            self = .bytes(data.makeBytes())
        case let bytes as NSData:
            var raw = [UInt8](repeating: 0, count: bytes.length)
            bytes.getBytes(&raw, length: bytes.length)
            self = .bytes(raw)
        case let date as Date:
            self = .date(date)
        case let date as NSDate:
            let date = Date(timeIntervalSince1970: date.timeIntervalSince1970)
            self = .date(date)
        default:
            self = .null
        }
    }

    /// Initialize a node with a foundation dictionary
    /// - parameter any: the dictionary to initialize with
    public init(json: [String: Any]) throws {
        var mutable: [String: StructuredData] = [:]
        try json.forEach { key, val in
            mutable[key] = try StructuredData(json: val)
        }
        self = .object(mutable)
    }

    /// Initialize a node with a json array
    /// - parameter any: the array to initialize with
    public init(json: [Any]) throws {
        let array = try json.map(StructuredData.init)
        self = .array(array)
    }

    /// Creates a FoundationJSON representation of the
    /// data for serialization w/ JSONSerialization
    public var json: Any {
        switch self {
        case .array(let values):
            return values.map { $0.json }
        case .bool(let value):
            return value
        case .bytes(let bytes):
            return bytes.base64Encoded.makeString()
        case .null:
            return NSNull()
        case .number(let number):
            switch number {
            case .double(let value):
                return value
            case .int(let value):
                return value
            case .uint(let value):
                return value
            }
        case .object(let values):
            var dictionary: [String: Any] = [:]
            for (key, value) in values {
                dictionary[key] = value.json
            }
            return dictionary
        case .string(let value):
            return value
        case .date(let date):
            let string = Date.outgoingDateFormatter.string(from: date)
            return string
        }
    }
}
