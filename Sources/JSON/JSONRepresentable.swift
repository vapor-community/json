import Node

enum JSONRepresentableError: Swift.Error {
    case missingContext
    case unknownContext(Context)
}

public protocol JSONRepresentable: NodeRepresentable {
    func makeJSON() throws -> JSON
}

extension NodeRepresentable where Self: JSONRepresentable {
    public func makeNode(in context: Context?) throws -> Node {
        guard let context = context else { throw JSONRepresentableError.missingContext }
        guard context.isJSON else { throw JSONRepresentableError.unknownContext(context) }
        let json = try makeJSON()
        return Node(json)
    }
}

public protocol JSONInitializable: NodeInitializable {
    init(json: JSON) throws
}

extension NodeInitializable where Self: JSONInitializable {
    public init(node: Node) throws {
        guard node.context.isJSON else { throw JSONRepresentableError.unknownContext(node.context) }
        let json = JSON(node)
        try self.init(json: json)
    }
}

public protocol JSONConvertible: JSONRepresentable, JSONInitializable {}

extension JSON: JSONRepresentable {
    public func makeJSON() -> JSON {
        return self
    }

    public init(json: JSON) {
        self = json
    }
}
