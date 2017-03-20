import Foundation
import Core
@_exported import Node

public struct JSON: StructuredDataWrapper {
    public static var defaultContext: Context? = jsonContext
    public var wrapped: StructuredData
    public let context: Context

    public init(_ wrapped: StructuredData, in context: Context? = defaultContext) {
        self.wrapped = wrapped
        self.context = context ?? jsonContext
    }
}

extension JSON {
    public init() {
        self.init([:])
    }
}
