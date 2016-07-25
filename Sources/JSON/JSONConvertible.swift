public protocol JSONRepresentable: NodeRepresentable {
    func makeJSON() throws -> JSON
}

extension JSONRepresentable {
    public func makeJSON() throws -> JSON {
        let node = try makeNode()
        return try JSON(node)
    }
}

protocol JSONInitializable: NodeInitializable {
    init(_ json: JSON) throws
}

extension NodeInitializable {
    public init(_ json: JSON) throws {
        let node = try json.makeNode()
        try self.init(node)
    }
}

protocol JSONConvertible: JSONRepresentable, JSONInitializable {}
