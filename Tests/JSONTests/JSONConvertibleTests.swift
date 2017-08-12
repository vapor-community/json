import XCTest
import JSON
import Core

extension Double: JSONCodeable {}
extension Array: JSONCodeable {}

class Person: JSONCodeable {
    let name: String
    let age: Int
    let luckyNumbers: [Double]
    let child: Person?

    static func jsonKeyMap(key: CodingKey) -> String {
        let string = key.stringValue
        switch string {
        case "name":
            return "NAME"
        default:
            return string
        }
    }

    init(name: String, age: Int, child: Person? = nil) {
        self.name = name
        self.age = age
        self.child = child
        self.luckyNumbers = [7.5]
    }
}

class JSONConvertibleTests: XCTestCase {
    func testJSONKeyed() throws {
        let data = """
        {
            "NAME": "human-name",
            "age": 25,
            "luckyNumbers": [3.14, 5.0],
            "child": {
                "NAME": "blah",
                "age": 12,
                "child": null,
                "luckyNumbers": [3.14, 5.0]
            }
        }
        """.data(using: .utf8)!


        let person = try! Person(json: data)
        print(person)
        XCTAssertEqual(person.name, "human-name")
        XCTAssertEqual(person.age, 25)
        XCTAssertEqual(person.child?.name, "blah")
        XCTAssertEqual(person.luckyNumbers, [3.14, 5.0])
    }

    func testJSONSingle() throws {
        let data = """
        3.14
        """.data(using: .utf8)!

        let decoder = try! JSON.JSONDecoder<Double>(data: data)
        let pi = try! Double(from: decoder)
        XCTAssertEqual(pi.string, 3.14.string)
    }

    func testJSONUnkeyed() throws {
        let data = """
        [1.0, 2.0, 3.14]
        """.data(using: .utf8)!

        let decoder = try! JSON.JSONDecoder<[Double]>(data: data)
        let arr = try [Double](from: decoder)
        print(arr)
        XCTAssertEqual(arr.count, 3)
    }

//    func testJSONRepresentable() throws {
//        let person = Person(name: "human-name", age: 25)
//        let json = try person.makeJSON()
//        XCTAssert(json["name"]?.string == "human-name")
//        XCTAssert(json["age"]?.int == 25)
//    }
//
//    func testSequenceJSONRepresentable() throws {
//        let people = [Person(name: "human-name", age: 25), Person(name: "other-human-name", age: 27)]
//        let array = try people.map { try $0.makeJSON() }
//        let json = JSON.array(array)
//        XCTAssert(json[0]?["name"]?.string == "human-name")
//        XCTAssert(json[0]?["age"]?.int == 25)
//        XCTAssert(json[1]?["name"]?.string == "other-human-name")
//        XCTAssert(json[1]?["age"]?.int == 27)
//    }
//
//    func testSetters() throws {
//        let person: Person? = Person(name: "human-name", age: 25)
//        var json = JSON()
//        try! json.set("person", to: person)
//        // try! json.set("persons", [person])
//        print(json)
//    }
//
//    func testGetters() throws {
//        var json = JSON()
//
//        try json.set("people", 0, "name", to: "Albert")
//        try json.set("people", 0, "age", to: 92)
//        try json.set("people", 1, "name", to: "Gertrude")
//        try json.set("people", 1, "age", to: 109)
//
//        let people: [Person] = try! json.get("people")
//        XCTAssertEqual(people.count, 2)
//
//        for person in people {
//            print(person.name)
//        }
//    }
//
//    static let allTests = [
//        ("testJSONInitializable", testJSONInitializable),
//        ("testJSONRepresentable", testJSONRepresentable),
//        ("testSequenceJSONRepresentable", testSequenceJSONRepresentable)
//    ]
}
