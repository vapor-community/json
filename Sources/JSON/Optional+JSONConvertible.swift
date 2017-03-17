extension Optional: JSONConvertible {
    public init(json: JSON) throws {
        // Check w/ `is` and cast later to
        // workaround bug
        guard Wrapped.self is JSONInitializable.Type else {
            throw InvalidContainer(
                container: "\(Optional.self)",
                element: "\(Wrapped.self)"
            )
        }
        guard json != .null else {
            self = .none
            return
        }

        let wrapped = Wrapped.self as! JSONInitializable.Type
        let mapped = try wrapped.init(json: json) as! Wrapped
        self = .some(mapped)
    }

    public func makeJSON() throws -> JSON {
        guard let value = self else { return .null }
        guard let representable = value as? JSONRepresentable else {
            throw InvalidContainer(
                container: "\(Optional.self)",
                element: "\(String(describing: value))"
            )
        }
        return try representable.makeJSON()
    }
}
