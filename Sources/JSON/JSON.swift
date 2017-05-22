import Foundation
import Core

#if COCOAPODS
    @_exported import NodeCocoapods
#else
    @_exported import Node
#endif

public struct JSON: StructuredDataWrapper {
    public static var defaultContext: Context? = jsonContext
    public var wrapped: StructuredData
    public let context: Context

    public init(_ wrapped: StructuredData, in context: Context? = defaultContext) {
        self.wrapped = wrapped
        self.context = context ?? jsonContext
    }
}
