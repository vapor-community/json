import Mapper

public enum JSON {
    case string(String)
    case int(Int)
    case double(Double)
    case array([JSON])
    case object([String: JSON])
    case bool(Bool)
    case null
}

// MARK: protocols

public protocol JSONInitializable {
    init(json: JSON) throws
}

public protocol JSONRepresentable {
    func makeJSON() throws -> JSON
}

public typealias JSONConvertible = JSONInitializable & JSONRepresentable

// MARK: convenience inits

extension JSON {
    public init() {
        self = .object([:])
    }

    public init(_ json: JSONRepresentable) throws {
        try self.init(json: json.makeJSON())
    }
}

// MARK: conform self

extension JSON: JSONConvertible {
    public init(json: JSON) throws {
        self = json
    }

    public func makeJSON() throws -> JSON {
        return self
    }
}


// MARK: map

extension JSON: MapConvertible {
    public init(map: Map) throws {
        switch map {
        case .array(let array):
            let array = try array.map { try JSON(map: $0) }
            self = .array(array)
        case .dictionary(let dict):
            let obj = try dict.mapValues { try JSON(map: $0) }
            self = .object(obj)
        case .double(let double):
            self = .double(double)
        case .int(let int):
            self = .int(int)
        case .string(let string):
            self = .string(string)
        case .bool(let bool):
            self = .bool(bool)
        case .null:
            self = .null
        }
    }

    public func makeMap() throws -> Map {
        switch self {
        case .array(let array):
            let array = try array.map { try $0.makeMap() }
            return .array(array)
        case .object(let obj):
            var dict: [String: Map] = [:]
            for (key, val) in obj {
                dict[key] = try val.makeMap()
            }
            return .dictionary(dict)
        case .double(let double):
            return .double(double)
        case .int(let int):
            return .int(int)
        case .string(let string):
            return .string(string)
        case .bool(let bool):
            return .bool(bool)
        case .null:
            return .null
        }
    }
}

extension Map: JSONConvertible {
    public init(json: JSON) throws {
        self = try json.makeMap()
    }

    public func makeJSON() throws -> JSON {
        return try JSON(map: self)
    }
}

// MARK: convenience access

extension JSON: Polymorphic {}
