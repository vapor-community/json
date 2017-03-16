import Core
import Jay
import Foundation


extension JSON {
    public init(
        serialized: BytesRepresentable,
        allowFragments: Bool = false
    ) throws {
        let serialized = try serialized.makeBytes()
        try self.init(serialized: serialized, allowFragments: allowFragments)
    }

    public init(
        serialized: Bytes,
        allowFragments: Bool = false
    ) throws {
        let options: JSONSerialization.ReadingOptions
        if allowFragments {
            options = .allowFragments
        } else {
            options = .init(rawValue: 0)
        }

        let data = Data(bytes: serialized)
        let json = try JSONSerialization.jsonObject(with: data, options: options)
        let structuredData = StructuredData(any: json)
        self = JSON(structuredData)
    }
}

extension StructuredData {
    /**
     Attempt to initialize a node with a foundation object.

     - warning: will default to null if unexpected value
     - parameter any: the object to create a node from
     - throws: if fails to create node.
     */
    public init(any: Any) {
        switch any {
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
            self = StructuredData(any: object)
        case let array as [Any]:
            self = .array(array.map(StructuredData.init))
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

    /**
     Initialize a node with a foundation dictionary
     - parameter any: the dictionary to initialize with
     */
    public init(any: [String: Any]) {
        var mutable: [String: StructuredData] = [:]
        any.forEach { key, val in
            mutable[key] = StructuredData(any: val)
        }
        self = .object(mutable)
    }

    /**
     Initialize a node with a foundation array
     - parameter any: the array to initialize with
     */
    public init(any: [Any]) {
        let array = any.map(StructuredData.init)
        self = .array(array)
    }

    /**
     Create an any representation of the node,
     intended for Foundation environments.
     */
    public var any: Any {
        switch self {
        case .object(let ob):
            var mapped: [String : Any] = [:]
            ob.forEach { key, val in
                mapped[key] = val.any
            }
            return mapped
        case .array(let array):
            return array.map { $0.any }
        case .bool(let bool):
            return bool
        case .number(let number):
            return number.double
        case .string(let string):
            return string
        case .null:
            return NSNull()
        case .bytes(let bytes):
            var bytes = bytes
            let data = NSData(bytes: &bytes, length: bytes.count)
            return data
        case .date(let date):
            return date
        }
    }

    var json: Any {
        switch self {
        case .array(let values):
            return values.map { $0.json }
        case .bool(let value):
            return value
        case .bytes(let bytes):
            return bytes.base64Encoded.string
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
