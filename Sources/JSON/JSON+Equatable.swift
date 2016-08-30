extension JSON: Equatable {
    public static func ==(lhs: JSON, rhs: JSON) -> Bool {
        return lhs.node == rhs.node
    }
}
