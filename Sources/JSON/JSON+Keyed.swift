import Mapper

// MARK: keyed

extension JSON: Keyed {
    public static var empty: JSON { return .object([:]) }

    public mutating func set(key: PathComponent, to value: JSON?) {
        switch key {
        case .index(let index):
            var arr = array ?? []
            arr[safe: index] = value
            self = .array(arr)
        case .key(let key):
            var obj = dictionary ?? [:]
            obj[key] = value
            self = .object(obj)
        }
    }

    public func get(key: PathComponent) -> JSON? {
        switch key {
        case .index(let index):
            return array?[safe: index]
        case .key(let key):
            return dictionary?[key]
        }
    }
}

// MARK: keyed convenience

extension JSON {
    public mutating func set<T: JSONRepresentable>(_ path: Path..., to json: T) throws {
        try set(path, to: json) { try $0.makeJSON() }
    }

    public func get<T: JSONInitializable>(_ path: Path...) throws -> T {
        return try get(path) { try T.init(json: $0) }
    }
}

