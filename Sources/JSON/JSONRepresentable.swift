public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

public protocol JSONInitializable {
    init(json: JSON)
}

public protocol JSONConvertible: JSONRepresentable, JSONInitializable {}

extension JSONRepresentable where Self: NodeRepresentable {
    public func makeJSON() throws -> JSON {
        let node = try makeNode()
        return try JSON(node: node)
    }
}

extension JSONInitializable where Self: NodeInitializable {
    public init(json: JSON) throws {
        let node = json.makeNode()
        try self.init(node: node)
    }
}
