import XCTest
@testable import JSON
import Core
import Node

class Person: JSONConvertible, NodeConvertible {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    required init(node: Node) throws {
        name = try node.get("name")
        age = try node.get("age")
    }

    func makeNode(in context: Context? = nil) throws -> Node {
        return try Node(node: ["name": name, "age": age])
    }
}

class JSONConvertibleTests: XCTestCase {
    static let allTests = [
        ("testJSONInitializable", testJSONInitializable),
        ("testJSONRepresentable", testJSONRepresentable)
    ]

    func testJSONInitializable() throws {
        let json = try JSON(node: ["name": "human-name", "age": 25])
        let person = try Person(json: json)
        XCTAssert(person.name == "human-name")
        XCTAssert(person.age == 25)
    }

    func testJSONRepresentable() throws {
        let person = Person(name: "human-name", age: 25)
        let json = try person.makeJSON()
        XCTAssert(json["name"]?.string == "human-name")
        XCTAssert(json["age"]?.int == 25)
    }
    
    func testSequenceJSONRepresentable() throws {
        let people = [Person(name: "human-name", age: 25), Person(name: "other-human-name", age: 27)]
        let json = try people.makeJSON()
        XCTAssert(json[0]?["name"]?.string == "human-name")
        XCTAssert(json[0]?["age"]?.int == 25)
        XCTAssert(json[1]?["name"]?.string == "other-human-name")
        XCTAssert(json[1]?["age"]?.int == 27)

    }

}
