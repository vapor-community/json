import Core

extension JSON {
    public init(
        serialized: Bytes,
        allowComments: Bool = true,
        omitNulls: Bool = true,
        allowFragments: Bool = true
    ) throws {

        var options: JSONSerialization.ReadingOptions = []

        if allowFragments {
            options.insert(.allowFragments)
        }

        var serialized = serialized

        if allowComments {
            serialized = serialized.commentsRemoved()
        }

        let data = Data(bytes: serialized)
        let json = try JSONSerialization.jsonObject(with: data)
        let node = Node._cast(json)
        self = JSON(node)
    }
}

// MARK: Nasty foundation code

extension Sequence where Iterator.Element == Byte {
    func commentsRemoved() -> Bytes {
        var commentsRemoved: Bytes = []

        var previousWasForwardSlash = false
        var previousWasAsterisk = false

        var multilineComment = false
        var lineComment = false

        for byte in self {
            if multilineComment {
                if previousWasAsterisk {
                    previousWasAsterisk = false
                    switch byte {
                    case Byte.forwardSlash:
                        multilineComment = false
                    default:
                        break
                    }
                } else {
                    switch byte {
                    case Byte.asterisk:
                        previousWasAsterisk = true
                    default:
                        break
                    }
                }
            } else if lineComment {
                switch byte {
                case Byte.newLine:
                    lineComment = false
                default:
                    break
                }
            } else if previousWasForwardSlash {
                previousWasForwardSlash = false

                switch byte {
                case Byte.asterisk:
                    multilineComment = true
                case Byte.forwardSlash:
                    lineComment = true
                default:
                    commentsRemoved.append(byte)
                }
            } else {
                switch byte {
                case Byte.forwardSlash:
                    previousWasForwardSlash = true
                default:
                    commentsRemoved.append(byte)
                }
            }
        }

        return commentsRemoved
    }
}

import Foundation

extension Node {
    fileprivate static func _cast(_ anyObject: Any) -> Node {
        if let double = anyObject as? Double {
            if double == Double(Int(double)) {
                let int = Int(double)
                return .number(.int(int))
            }

            return .number(Node.Number(double))
        }

        #if os(Linux)
            if let dict = anyObject as? [String: Any] {
                var object: [String: JSON] = [:]
                for (key, val) in dict {
                    object[key] = _cast(val)
                }
                return .object(object)
            } else if let array = anyObject as? [Any] {
                return .array(array.map { _cast($0) })
            }

            if let int = anyObject as? Int {
                return .number(.int(int))
            } else if let bool = anyObject as? Bool {
                return .bool(bool)
            }
        #else
            if let dict = anyObject as? [String: AnyObject] {
                var object: [String: Node] = [:]
                for (key, val) in dict {
                    object[key] = _cast(val)
                }
                return .object(object)
            } else if let array = anyObject as? [AnyObject] {
                return .array(array.map { _cast($0) })
            }
        #endif

        if let string = anyObject as? String {
            return .string(string)
        }
        
        return .null
    }
}

