import Foundation
import Core

// MARK: Serialization

extension JSON: BytesConvertible {
    public func makeBytes() throws -> Bytes {
        return try serialize()
    }

    public init(bytes: Bytes) throws {
        try self.init(serialized: bytes)
    }
}

// MARK: Nasty Foundation code

extension JSON {
    private init(serialized: Bytes) throws {
        let data = Data(bytes: serialized)
        let json = try JSONSerialization.jsonObject(with: data)

        self = JSON._cast(json)
    }

    private static func _cast(_ anyObject: Any) -> JSON {
        if let double = anyObject as? Double {
            if double == Double(Int(double)) {
                let int = Int(double)
                return .number(.integer(int))
            } else {
                return .number(.double(double))
            }
        }

        #if os(Linux)
            if let dict = anyObject as? [String: Any] {
                var object: [String: JSON] = [:]
                for (key, val) in dict {
                    object[key] = _cast(val)
                }
                return .object(object)
            } else if let array = anyObject as? [Any] {
                return .array(array.map { _cast($0) })
            }

            if let int = anyObject as? Int {
                return .number(.integer(int))
            } else if let bool = anyObject as? Bool {
                return .bool(bool)
            }
        #else
            if let dict = anyObject as? [String: AnyObject] {
                var object: [String: JSON] = [:]
                for (key, val) in dict {
                    object[key] = _cast(val)
                }
                return .object(object)
            } else if let array = anyObject as? [AnyObject] {
                return .array(array.map { _cast($0) })
            }
        #endif

        if let string = anyObject as? String {
            return .string(string)
        }

        return .null
    }

    private func serialize() throws -> Bytes {
        let object = JSON._uncast(self)
        let data = try JSONSerialization.data(withJSONObject: object)

        var buffer = Bytes(repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)

        return buffer
    }

    private static func _uncast(_ json: JSON) -> AnyObject {
        switch json {
        case .object(let object):
            let dict = NSMutableDictionary()
            for (key, val) in object {
                dict.setValue(_uncast(val), forKey: key)
            }
            return dict.copy()
        case .array(let array):
            let nsarray = NSMutableArray()
            for item in array {
                nsarray.add(_uncast(item))
            }
            return nsarray.copy()
        case .number(let number):
            switch number {
            case .double(let double):
                return NSNumber(floatLiteral: double)
            case .integer(let int):
                return NSNumber(integerLiteral: int)
            }
        case .string(let string):
            return NSString(string: string)
        case .bool(let bool):
            return NSNumber(booleanLiteral: bool)
        case .null:
            return NSNull()
        }
    }
}
