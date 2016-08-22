extension JSON: Equatable {
    public static func ==(lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.object(let l), .object(let r)):
            return l == r
        case (.array(let l), .array(let r)):
            return l == r
        case (.number(let n), .bool(let b)):
            return n.bool == b
        case (.bool(let b), .number(let n)):
            return b == n.bool
        case (.number(let l), .number(let r)):
            return l == r
        case (.string(let l), .string(let r)):
            return l == r
        case (.bool(let l), .bool(let r)):
            return l == r
        case (.null, .null):
            return true
        default:
            return false
        }
    }
}
