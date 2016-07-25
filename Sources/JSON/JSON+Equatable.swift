extension JSON: Equatable {}
public func ==(lhs: JSON, rhs: JSON) -> Bool {
    switch (lhs, rhs) {
    case (.object(let l), .object(let r)):
        return l == r
    case (.array(let l), .array(let r)):
        return l == r
    case (.number(let n), .bool(let b)):
        switch n {
        case .integer(let int):
            if b {
                return int == 1
            } else {
                return int == 0
            }
        default:
            return false
        }
    case (.bool(let b), .number(let n)):
        switch n {
        case .integer(let int):
        if b {
                return int == 1
            } else {
                return int == 0
            }
        default:
            return false
        }
    case (.number(let l), .number(let r)):
        switch (l, r) {
        case (.integer(let i), .double(let d)):
            return Double(i) == d
        case (.integer(let il), .integer(let ir)):
            return il == ir
        case (.double(let dl), .double(let dr)):
            return dl == dr
        case (.double(let d), .integer(let i)):
            return Double(i) == d
        }
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
