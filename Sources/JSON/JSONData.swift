import Foundation
import Mapper

internal struct JSONData {
    var raw: Any
}

extension JSONData: Polymorphic {
    var string: String? {
        return raw as? String
    }

    var int: Int? {
        return raw as? Int
    }

    var double: Double? {
        return raw as? Double
    }

    var bool: Bool? {
        return raw as? Bool
    }

    var dictionary: [String : JSONData]? {
        guard let dict = raw as? [String: Any] else {
            return nil
        }

        return dict.mapValues { .init(raw: $0) }
    }

    var isNull: Bool {
        return raw as? NSNull != nil
    }

    var array: [JSONData]? {
        guard let array = raw as? [Any] else {
            return nil
        }

        return array.map { .init(raw: $0) }
    }
}
