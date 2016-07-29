import XCTest
@testable import JSON
import Core

class Person: JSONConvertible, NodeConvertible {
    let name: String
    let age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    required init(node: Node, in context: Context) throws {
        name = try node.extract("name")
        age = try node.extract("age")
    }

    func makeNode() throws -> Node {
        return try Node(node: ["name": name, "age": age])
    }
}

class JSONConvertibleTests: XCTestCase {
    static let allTests = [
        ("testJSONInitializable", testJSONInitializable),
        ("testJSONRepresentable", testJSONRepresentable)
    ]

    func testJSONInitializable() throws {
        let json = JSON.object(["name": .string("human-name"), "age": .number(25)])
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
}
