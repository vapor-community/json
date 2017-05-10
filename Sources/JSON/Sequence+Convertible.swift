import Node

extension Sequence where Iterator.Element: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        let json: [StructuredData] = try map {
            try $0.makeJSON().wrapped
        }
        return JSON(.array(json))
    }
}
