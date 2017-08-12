import JSON

struct Name: JSONCodable {
    let first: String
    let last: String
    var full: String {
        return first + " " + last
    }
}

class Person: JSONCodable {
    let name: Name
    let age: Int
    let luckyNumbers: [Double]

    static func jsonKeyMap(key: CodingKey) -> CodingKey {
        let string = key.stringValue
        switch string {
        case "luckyNumbers":
            return StringKey("lucky_numbers")
        default:
            return key
        }
    }

    init(name: Name, age: Int, luckyNumbers: [Double]) {
        self.name = name
        self.age = age
        self.luckyNumbers = luckyNumbers
    }
}

struct KitchenSink: JSONCodable {
    let bool: Bool
    let string: String
    let int: Int
    let double: Double
    let object: [String: String]
    let array: [String]
}
