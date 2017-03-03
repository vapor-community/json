import Foundation
import Core
@_exported import Node

public struct JSON: StructuredDataWrapper {
    public var wrapped: StructuredData
    public let context: Context

    public init(_ wrapped: StructuredData, in context: Context) {
        self.wrapped = wrapped
        self.context = context
    }
}
