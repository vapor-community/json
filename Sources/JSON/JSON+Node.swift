@_exported import Node

extension JSON: NodeConvertible {
    public func makeNode() throws -> Node {
        switch self {
        case .object(let object):
            var node: [String: Node] = [:]
            for (key, val) in object {
                node[key] = try val.makeNode()
            }
            return .object(node)
        case .array(let array):
            let node = try array.map { try $0.makeNode() }
            return .array(node)
        case .number(let number):
            switch number {
            case .double(let double):
                return .number(.double(double))
            case .integer(let int):
                return .number(.int(int))
            }
        case .string(let string):
            return .string(string)
        case .bool(let bool):
            return .bool(bool)
        case .null:
            return .null
        }
    }

    public init(with node: Node, in context: Context) throws {
        switch node {
        case .null:
            self = .null
        case .bool(let bool):
            self = .bool(bool)
        case .number(let number):
            switch number {
            case .uint(let uint):
                self = .number(.integer(Int(uint)))
            case .int(let int):
                self = .number(.integer(int))
            case .double(let double):
                self = .number(.double(double))
            }
        case .string(let string):
            self = .string(string)
        case .array(let array):
            let json = try array.map { try JSON(with: $0, in: $0) }
            self = .array(json)
        case .object(let object):
            var json: [String: JSON] = [:]
            for (key, val) in object {
                json[key] = try JSON(with: val, in: val)
            }
            self = .object(json)
        case .bytes(let bytes):
            self = .string(bytes.base64String)
        }
    }
}
