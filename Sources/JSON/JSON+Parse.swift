import Core
import Jay

public enum JSONError: Error {
    case allowFragmentsNotSupported
    case parse(path: String, error: Error)
}

extension JSON {
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
        self = JSON(json.toNode())
    }
}
