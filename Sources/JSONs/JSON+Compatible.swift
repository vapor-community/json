import Mapper

// This file conforms various Swift Standard Library types
// to JSONConvertible.
//
// Note: conditional conformance will help make this more type safe.

extension Array: JSONConvertible {
    public init(json: JSON) throws {
        guard Element.self is JSONInitializable.Type else {
            throw MapError.missingConformance(type: Element.self, isNot: JSONInitializable.self)
        }
        let metaType = Element.self as! JSONInitializable.Type

        let array = try json.assertArray()
        self = try array.map { try metaType.init(json: $0) as! Element }
    }

    public func makeJSON() throws -> JSON {
        guard Element.self is JSONRepresentable.Type else {
            throw MapError.missingConformance(type: Element.self, isNot: JSONRepresentable.self)
        }

        let array = try map { try ($0 as! JSONRepresentable).makeJSON() }
        return .array(array)
    }
}

extension Dictionary: JSONConvertible {
    public init(json: JSON) throws {
        guard Value.self is JSONInitializable.Type else {
            throw MapError.missingConformance(type: Value.self, isNot: JSONInitializable.self)
        }
        guard Key.self is String.Type else {
            throw MapError.missingConformance(type: Key.self, isNot: String.self)
        }
        let metaType = Element.self as! JSONInitializable.Type

        let object = try json.assertDictionary()
        var dict: [Key: Value] = [:]
        try object.forEach { el in
            let val = try metaType.init(json: el.value) as! Value
            dict[el.key as! Key] = val
        }
        self = dict
    }

    public func makeJSON() throws -> JSON {
        guard Value.self is JSONRepresentable.Type else {
            throw MapError.missingConformance(type: Value.self, isNot: JSONRepresentable.self)
        }
        guard Key.self is String.Type else {
            throw MapError.missingConformance(type: Key.self, isNot: String.self)
        }

        var dict: [String: JSON] = [:]
        try forEach { el in
            let val = try (el.value as! JSONRepresentable).makeJSON()
            dict[el.key as! String] = val
        }
        return .object(dict)
    }
}

extension Optional: JSONConvertible {
    public init(json: JSON) throws {
        guard !json.isNull else {
            self = .none
            return
        }

        guard Wrapped.self is JSONInitializable.Type else {
            throw MapError.missingConformance(type: Wrapped.self, isNot: JSONInitializable.self)
        }

        let metaType = Wrapped.self as! JSONInitializable.Type
        let value = try metaType.init(json: json)

        self = .some(value as! Wrapped)
    }

    public func makeJSON() throws -> JSON {
        guard Wrapped.self is JSONRepresentable.Type else {
            throw MapError.missingConformance(type: Wrapped.self, isNot: JSONRepresentable.self)
        }
        switch self {
        case .none:
            return .null
        case .some(let wrapped):
            return try (wrapped as! JSONRepresentable).makeJSON()
        }
    }
}

extension String: JSONConvertible {
    public init(json: JSON) throws { self = try json.assertString() }
    public func makeJSON() throws -> JSON { return .string(self) }
}

extension Int: JSONConvertible {
    public init(json: JSON) throws { self = try json.assertInt() }
    public func makeJSON() throws -> JSON { return .int(self) }
}

extension Double: JSONConvertible {
    public init(json: JSON) throws { self = try json.assertDouble() }
    public func makeJSON() throws -> JSON { return .double(self) }
}




