import Core
import JSON

struct Name: JSONCodable {
    static var jsonKeyMap = [
        "first": "first_name"
    ]

    let first: String
    let last: String
    var full: String {
        return first + " " + last
    }
}

class Person: JSONCodable {
    static var jsonKeyMap = [
        "luckyNumbers": "lucky_numbers"
    ]

    let name: Name
    let age: Int
    let luckyNumbers: [Double]

    init(name: Name, age: Int, luckyNumbers: [Double]) {
        self.name = name
        self.age = age
        self.luckyNumbers = luckyNumbers
    }
}

struct KitchenSink: JSONCodable {
    let array: [String]
    let bool: Bool
    let string: String
    let int: Int
    let double: Double
    let object: [String: String]
}
