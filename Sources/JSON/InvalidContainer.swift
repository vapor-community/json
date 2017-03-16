import Debugging

public struct InvalidContainer: Debuggable {
    public let container: String
    public let element: String
}

extension InvalidContainer {
    public var identifier: String {
        return "invalidContainer"
    }

    public var reason: String {
        return "Unable to use container '\(container)' with element '\(element)' expected a \(JSONConvertible.self) type"
    }

    public var possibleCauses: [String] {
        return [
            "tried to use a collection (Optional, Array, Dictionary, Set) that doesn't contain JSONConvertible types"
        ]
    }

    public var suggestedFixes: [String] {
        return [
            "ensure that '\(element)' conforms to '\(NodeConvertible.self)'",
            "if '\(element)' is itself a collection (Optional, Array, Dictionary, Set), then ensure it's elements are '\(NodeConvertible.self)'",
            "if the element type is `Any`, then manually inspect to ensure all elements contained conform to '\(NodeConvertible.self)'",
            "if container is a dictionary, ensure Key is type String, and Value is '\(NodeConvertible.self)'"
        ]
    }
}

