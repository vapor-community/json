@_exported import PathIndexable

extension JSON: PathIndexable {

    /**
        If self is an array representation, return array
    */
    public var pathIndexableArray: [JSON]? {
        guard case let .array(array) = _node else { return nil }
        return array.map { JSON(_node: $0) }
    }

    /**
        If self is an object representation, return object
     */
    public var pathIndexableObject: [String: JSON]? {
        guard case let .object(o) = _node else { return nil }
        var object: [String: JSON] = [:]
        for (key, val) in o {
            object[key] = JSON(_node: val)
        }
        return object
    }

    /**
        Initialize json w/ array
    */
    public convenience init(_ array: [JSON]) {
        let array = array.map { $0._node }
        let node = Node.array(array)
        self.init(_node: node)
    }

    /**
        Initialize json w/ object
    */
    public convenience init(_ o: [String: JSON]) {
        var object: [String: Node] = [:]
        for (key, val) in o {
            object[key] = val._node
        }
        let node = Node.object(object)
        self.init(_node: node)
    }
}
