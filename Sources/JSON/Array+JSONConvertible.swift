extension Array: JSONConvertible {
    public init(json: JSON) throws {
        guard Element.self is JSONInitializable.Type else {
            throw InvalidContainer(
                container: "\(Array.self)",
                element: "\(Element.self)"
            )
        }

        let element = Element.self as! JSONInitializable.Type
        let array = json.typeArray ?? [json]
        let mapped = try array.map { try element.init(json: $0) as! Element }
        self = mapped
    }

    public func makeJSON() throws -> JSON {
        let mapped = try representable() .map { try $0.makeJSON() }
        return JSON(mapped)
    }
}

extension Array {
    /// this is a work around to casting limitations on Linux
    fileprivate func representable() throws -> [JSONRepresentable] {
        return try self.map {
            guard let representable = $0 as? JSONRepresentable else {
                throw InvalidContainer(
                    container: "\(Array.self)",
                    element: "\(String(describing: $0))"
                )
            }
            return representable
        }
    }
}
