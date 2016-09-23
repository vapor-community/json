import Node

extension Sequence where Iterator.Element: NodeRepresentable {
    func makeJSON() throws -> JSON {
        return try self.makeNode().converted(to: JSON.self)
    }
}
