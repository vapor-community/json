import Node

extension Sequence where Iterator.Element: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        return try JSON(node: self.map({ try $0.makeJSON() }))
    }
}
