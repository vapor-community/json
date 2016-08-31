import Core

extension JSON {
    public func serialize(
        prettyPrint: Bool = false
    ) throws -> Bytes {
        let object = Node._uncast(node)

        var options: JSONSerialization.WritingOptions = []

        if prettyPrint {
            options.insert(.prettyPrinted)
        }

        let data = try JSONSerialization.data(withJSONObject: object, options: options)

        var buffer = Bytes(repeating: 0, count: data.count)
        data.copyBytes(to: &buffer, count: data.count)

        return buffer
    }
}


import Foundation

// MARK: Nasty Foundation code

extension Node {
    fileprivate static func _uncast(_ node: Node) -> Any {
        switch node {
        case .object(let object):
            let dict = NSMutableDictionary()
            for (key, val) in object {
                dict[NSString(string: key)] = _uncast(val)
            }
            return dict.copy()
        case .array(let array):
            let nsarray = NSMutableArray()
            for item in array {
                nsarray.add(_uncast(item))
            }
            return nsarray.copy()
        case let .number(.double(double)):
            return NSNumber(value: double)
        case let .number(.int(int)):
            return NSNumber(value: int)
        case let .number(.uint(uint)):
            return NSNumber(value: uint)
        case .string(let string):
            return NSString(string: string)
        case .bool(let bool):
            return NSNumber(booleanLiteral: bool)
        case .bytes(let bytes):
            return bytes.base64String
        case .null:
            return NSNull()
        }
    }
}
