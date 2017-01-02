import Node

extension JSON {
    public func permit(_ params: [String]) -> JSON {
        guard var object = node.object as? [String:Node] else { return self }
        
        object.forEach { key,_ in
            if(!params.contains(key)) {
                object[key] = nil
            }
        }

        return JSON(Node.object(object))
    }
}
