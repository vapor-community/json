import Node

extension Sequence where Iterator.Element: NodeRepresentable {
    public func makeJSON() throws -> JSON {
        return try self.makeNode().converted(to: JSON.self)
    }
}
