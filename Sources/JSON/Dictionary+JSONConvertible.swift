extension Dictionary: JSONConvertible {
    public init(json: JSON) throws {
        // check w/ `is` and cast later to work around casting bug
        guard
            Key.self is String.Type,
            Value.self is JSONInitializable.Type
            else {
                throw InvalidContainer(
                    container: "\(Dictionary.self)",
                    element: "\(Value.self)"
                )
            }

        let object = json.object ?? [:]
        let value = Value.self as! JSONInitializable.Type

        var mapped: [Key: Value] = [:]

        try object.forEach { key, json in
            let key = key as! Key
            let val = try value.init(json: json) as! Value
            mapped[key] = val
        }

        self = mapped
    }

    public func makeJSON() throws -> JSON {
        let object = try representable()

        var mapped: [String: JSON] = [:]
        try object.forEach { key, value in
            mapped[key] = try value.makeJSON()
        }
        return JSON(mapped)
    }
}

extension Dictionary {
    fileprivate func representable() throws -> [String: JSONRepresentable] {
        guard Key.self is String.Type else {
            throw InvalidContainer(
                container: "\(Dictionary.self)",
                element: "Key(\(Key.self)) (expected String)"
            )
        }

        var object: [String: JSONRepresentable] = [:]
        try forEach { key, value in
            let key = key as! String
            guard let rep = value as? JSONRepresentable else {
                throw InvalidContainer(
                    container: "\(Dictionary.self)",
                    element: "\(String(describing: value))"
                )
            }
            object[key] = rep
        }
        
        return object
    }
}
