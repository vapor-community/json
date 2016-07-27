@_exported import PathIndexable

extension JSON: PathIndexable {

    /**
        If self is an array representation, return array
    */
    public var pathIndexableArray: [JSON]? {
        guard case let .array(array) = self else { return nil }
        return array
    }

    /**
        If self is an object representation, return object
     */
    public var pathIndexableObject: [String: JSON]? {
        guard case let .object(ob) = self else { return nil }
        return ob
    }

    /**
        Initialize json w/ array
    */
    public init(_ array: [JSON]) {
        self = .array(array)
    }

    /**
        Initialize json w/ object
    */
    public init(_ object: [String : JSON]) {
        self = .object(object)
    }
}
