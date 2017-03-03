import Node

public final class JSONContext: Context {
    internal static let shared = JSONContext()
    fileprivate init() {}
}

public let jsonContext = JSONContext.shared

extension Context {
    public var isJSON: Bool {
        guard let _ = self as? JSONContext else { return false }
        return true
    }
}
