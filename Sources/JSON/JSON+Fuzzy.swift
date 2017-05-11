extension JSON: FuzzyConverter {
    public static func represent<T>(
        _ any: T,
        in context: Context
    ) throws -> Node? {
        guard context.isJSON else {
            return nil
        }
        
        guard let r = any as? JSONRepresentable else {
            return nil
        }
        
        return try r.makeJSON().converted()
    }
    
    public static func initialize<T>(
        node: Node
    ) throws -> T? {
        guard node.context.isJSON else {
            return nil
        }
        
        guard let type = T.self as? JSONInitializable.Type else {
            return nil
        }
        
        let json = node.converted(to: JSON.self)
        return try type.init(json: json) as? T
    }
}
