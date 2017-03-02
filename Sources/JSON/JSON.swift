import Foundation
import Core
@_exported import Node

public struct JSON: SchemaWrapper {
    public var schema: Schema
    public let context: Context

    public init(schema: Schema, in context: Context) {
        self.schema = schema
        self.context = context
    }
}
