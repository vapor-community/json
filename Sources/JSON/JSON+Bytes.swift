import Core

extension JSON: BytesConvertible {
    public func makeBytes() throws -> Bytes {
        return try serialize()
    }

    public convenience init(bytes: Bytes) throws {
        try self.init(serialized: bytes)
    }
}
