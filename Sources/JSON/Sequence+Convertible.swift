import Node

extension Sequence where Iterator.Element: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        let mapped = try self.map({ try $0.makeJSON() })
        return try JSON(node: mapped)
    }
}
