import Core
import Jay

extension JSON {
    public func serialize(prettyPrint: Bool = false) throws -> Bytes {
        let formatting: Jay.Formatting = prettyPrint ? .prettified : .minified
        let json = node.toJSON()
        return try Jay(formatting: formatting).dataFromJson(json: json)
    }
}
