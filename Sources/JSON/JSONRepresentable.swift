import Node

public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONConvertible: JSONRepresentable, JSONInitializable {}

extension JSONRepresentable where Self: NodeRepresentable {
    public func makeJSON() throws -> JSON {
        let context = JSONContext()
        let node = try makeNode(context: context)
        return try JSON(node: node)
    }
}

extension JSONInitializable where Self: NodeInitializable {
    public init(json: JSON) throws {
        let node = json.makeNode()
        let context = JSONContext()
        try self.init(node: node, in: context)
    }
}

extension JSON: JSONConvertible {}
