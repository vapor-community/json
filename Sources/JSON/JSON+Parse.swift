import Core
import Jay

public enum JSONError: Error {
    case allowFragmentsNotSupported
}

extension JSON {
    public init(
        serialized: Bytes,
        allowComments: Bool = false,
        allowFragments: Bool = false
    ) throws {

        guard !allowFragments else {
            throw JSONError.allowFragmentsNotSupported
        }
        
        var serialized = serialized

        if allowComments {
            serialized = serialized.commentsRemoved()
        }

        let json = try Jay().jsonFromData(serialized)
        self = JSON(json.toNode())
    }
}

// MARK: Comment removal

extension Sequence where Iterator.Element == Byte {
    func commentsRemoved() -> Bytes {
        var commentsRemoved: Bytes = []

        var previousWasForwardSlash = false
        var previousWasAsterisk = false

        var multilineComment = false
        var lineComment = false

        var previousWasBackSlash = false
        var inString = false

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
            } else if previousWasBackSlash {
                previousWasBackSlash = false
                commentsRemoved.append(byte)
            } else if inString {
                switch byte {
                case Byte.quote:
                    inString = false
                    commentsRemoved.append(byte)
                case Byte.backSlash:
                    previousWasBackSlash = true
                    commentsRemoved.append(byte)
                default:
                    commentsRemoved.append(byte)
                }
            } else {
                switch byte {
                case Byte.forwardSlash:
                    previousWasForwardSlash = true
                case Byte.quote:
                    inString = true
                    commentsRemoved.append(byte)
                default:
                    commentsRemoved.append(byte)
                }
            }
        }

        return commentsRemoved
    }
}

