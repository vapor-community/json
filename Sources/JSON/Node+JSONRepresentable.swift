extension Node: JSONConvertible {
    public init(json: JSON) throws {
        self = json.converted()
    }

    public func makeJSON() throws -> JSON {
        return converted()
    }
}
