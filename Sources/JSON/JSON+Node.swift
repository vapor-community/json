@_exported import Node

extension JSON: NodeConvertible {
    public func makeNode() -> Node {
        switch self {
        case .object(let object):
            var node: [String: Node] = [:]
            for (key, val) in object {
                node[key] = val.makeNode()
            }
            return .object(node)
        case .array(let array):
            let node = array.map { $0.makeNode() }
            return .array(node)
        case .number(let number):
            return .number(number)
        case .string(let string):
            return .string(string)
        case .bool(let bool):
            return .bool(bool)
        case .null:
            return .null
        }
    }

    public init(with node: Node, in context: Context) {
        switch node {
        case .null:
            self = .null
        case .bool(let bool):
            self = .bool(bool)
        case .number(let number):
            self = .number(number)
        case .string(let string):
            self = .string(string)
        case .array(let array):
            let json = array.map { JSON(with: $0, in: $0) }
            self = .array(json)
        case .object(let object):
            var json: [String: JSON] = [:]
            for (key, val) in object {
                json[key] = JSON(with: val, in: val)
            }
            self = .object(json)
        case .bytes(let bytes):
            self = .string(bytes.base64String)
        }
    }
}
