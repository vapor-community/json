import Node

public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

public protocol JSONInitializable {
    init(json: JSON) throws
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
