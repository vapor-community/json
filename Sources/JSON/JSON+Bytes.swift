import Core

extension JSON: BytesConvertible {
    public func makeBytes() throws -> Bytes {
        let bytes = try JSON.Serializer.serialize(_node)
        return bytes.bytes
    }

    public convenience init(bytes: Bytes) throws {
        let node = try JSON.Parser.parse(bytes)
        self.init(_node: node)
    }
}
