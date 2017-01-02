import Node

extension JSON {
    func permit(_ params: [String]) -> JSON {
        guard var object = node.object as? [String:Node] else { return self }
        
        for (key, _) in object {
            if(!params.contains(key)) {
                object[key] = nil
            }
        }
        
        return JSON(Node.object(object))
    }
}
