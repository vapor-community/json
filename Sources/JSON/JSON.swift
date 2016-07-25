import Foundation
import Core

public enum JSON {
    public enum Number {
        case integer(Int)
        case double(Double)
    }

    case object([String: JSON])
    case array([JSON])
    case number(Number)
    case string(String)
    case bool(Bool)
    case null
}
