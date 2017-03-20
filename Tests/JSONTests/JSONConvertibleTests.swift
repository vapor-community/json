import XCTest
@testable import JSON
import Core
import Node

extension JSONConvertible where Self: NodeConvertible {
    init(node: Node) throws {
        try self.init(json: JSON(node))
    }

    public func makeNode(in context: Context?) throws -> Node {
        return try makeJSON().converted()
    }
}

class Person: JSONConvertible, NodeConvertible {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    required init(json: JSON) throws {
        name = try json.get("name")
        age = try json.get("age")
    }

    func makeJSON() throws -> JSON {
        return try JSON(node: ["name": name, "age": age])
    }
}

class JSONConvertibleTests: XCTestCase {
    static let allTests = [
        ("testJSONInitializable", testJSONInitializable),
        ("testJSONRepresentable", testJSONRepresentable),
        ("testSequenceJSONRepresentable", testSequenceJSONRepresentable)
    ]

    func testJSONInitializable() throws {
        let json = try JSON(node: ["name": "human-name", "age": 25])
        let person = try Person(node: json)
        XCTAssert(person.name == "human-name")
        XCTAssert(person.age == 25)
    }

    func testJSONRepresentable() throws {
        let person = Person(name: "human-name", age: 25)
        let json = try person.makeNode(in: jsonContext)
        XCTAssert(json["name"]?.string == "human-name")
        XCTAssert(json["age"]?.int == 25)
    }
    
    func testSequenceJSONRepresentable() throws {
        let people = [Person(name: "human-name", age: 25), Person(name: "other-human-name", age: 27)]
        let json = try people.makeNode(in: jsonContext)
        XCTAssert(json[0]?["name"]?.string == "human-name")
        XCTAssert(json[0]?["age"]?.int == 25)
        XCTAssert(json[1]?["name"]?.string == "other-human-name")
        XCTAssert(json[1]?["age"]?.int == 27)
    }

}
