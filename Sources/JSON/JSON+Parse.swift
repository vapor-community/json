import Core
import Jay

public enum JSONError: Swift.Error {
    case allowFragmentsNotSupported
    case parse(path: String, error: Swift.Error)
}

extension JSON {
    public init(
        serialized: BytesRepresentable,
        allowComments: Bool = false,
        allowFragments: Bool = false
    ) throws {
        let serialized = try serialized.makeBytes()
        try self.init(serialized: serialized, allowComments: allowComments, allowFragments: allowFragments)
    }

    public init(
        serialized: Bytes,
        allowComments: Bool = false,
        allowFragments: Bool = false
    ) throws {
        guard !allowFragments else {
            throw JSONError.allowFragmentsNotSupported
        }

        var parsing: Jay.ParsingOptions = []
        if allowComments {
            parsing.formUnion(.allowComments)
        }
        let json = try Jay(parsing: parsing).jsonFromData(serialized)
        self = JSON(json.toStructuredData())
    }
}
