import Core
import Jay
import Foundation

extension JSON {
    public func serialize(prettyPrint: Bool = false) throws -> Bytes {
        let options: JSONSerialization.WritingOptions
        if prettyPrint {
            options = .prettyPrinted
        } else {
            options = .init(rawValue: 0)
        }

        let json = wrapped.json
        let data = try JSONSerialization.data(withJSONObject: json, options: options)
        return data.makeBytes()
    }
}
