import Foundation
import Core

public enum JSON {
    case object([String: JSON])
    case array([JSON])
    case number(Node.Number)
    case string(String)
    case bool(Bool)
    case null
}
