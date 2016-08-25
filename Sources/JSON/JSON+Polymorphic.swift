@_exported import Polymorphic

extension JSON: Polymorphic {
    public var isNull: Bool { return _node.isNull }
    public var bool: Bool? { return _node.bool }
    public var double: Double? { return _node.double }
    public var int: Int? { return _node.int }
    public var string: String? { return _node.string }
    public var array: [Polymorphic]? { return _node.array }
    public var object: [String: Polymorphic]? { return _node.object }
}
