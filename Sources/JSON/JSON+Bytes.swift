import Core

extension JSON: BytesConvertible {
    public func makeBytes() throws -> Bytes {
        return try serialize()
    }

    public init(bytes: Bytes) throws {
        try self.init(bytes: bytes, allowFragments: false)
    }
}
