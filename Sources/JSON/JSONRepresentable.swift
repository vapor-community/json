import Node

public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONConvertible: JSONRepresentable, JSONInitializable {}

private let _context = JSONContext()

extension JSONRepresentable where Self: NodeRepresentable {
    public func makeJSON() throws -> JSON {
        let node = try makeNode(in: _context)
        return try JSON(node: node)
    }
}

extension JSONInitializable where Self: NodeInitializable {
    public init(json: JSON) throws {
        let node = json.makeNode()
        try self.init(node: node, in: _context)
    }
}

extension JSON: JSONConvertible {}
