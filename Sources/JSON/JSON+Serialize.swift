import Core
import Foundation

extension JSON {
    public func serialize(prettyPrint: Bool = false) throws -> Bytes {
        switch self {
        case .array, .object:
            return try _nsSerialize(prettyPrint: prettyPrint)
        case .bool(let b):
            return b ? [.t, .r, .u, .e] : [.f, .a, .l, .s, .e]
        case .string:
            let bytes = string?.makeBytes() ?? []
            return [.quote] + bytes + [.quote]
        case .int, .double:
            return string?.makeBytes() ?? []
        case .null:
            return [.n, .u, .l, .l]
        }
    }
    
    private func _nsSerialize(prettyPrint: Bool) throws -> Bytes {
        let options: JSONSerialization.WritingOptions
        if prettyPrint {
            options = .prettyPrinted
        } else {
            options = .init(rawValue: 0)
        }

        let data = try JSONSerialization.data(
            withJSONObject: foundationJSON,
            options: options
        )
        return data.makeBytes()
    }
}
