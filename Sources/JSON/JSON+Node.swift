@_exported import Node

extension JSON: NodeConvertible {
    public func makeNode() -> Node {
        return _node
    }

    public convenience init(node: Node, in context: Context) {
        self.init(_node: node)
    }
}
