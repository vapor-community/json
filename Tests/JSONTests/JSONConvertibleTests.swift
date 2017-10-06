import XCTest
@testable import JSON
import Core
import Node

class Person: JSONConvertible {
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
        var json = JSON([:])
        try json.set("name", name)
        try json.set("age", age)
        return json
    }
    
    required init(node: Node) throws {
        self.name = "node"
        self.age = 15
    }
    
    func makeNode(in context: Context?) throws -> Node {
        return Node(["foo": "bar"])
    }
}

class JSONConvertibleTests: XCTestCase {
    static let allTests = [
        ("testJSONInitializable", testJSONInitializable),
        ("testJSONRepresentable", testJSONRepresentable),
        ("testSequenceJSONRepresentable", testSequenceJSONRepresentable),
        ("testSetters", testSetters),
        ("testGetters", testGetters)
    ]
    
    override func setUp() {
        Node.fuzzy = [JSON.self, Node.self]
    }

    func testJSONInitializable() throws {
        var json = JSON()
        try json.set("name", "human-name")
        try json.set("age", 25)
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
        let array = try people.map { try $0.makeJSON() }
        let json = JSON.array(array)
        XCTAssert(json[0]?["name"]?.string == "human-name")
        XCTAssert(json[0]?["age"]?.int == 25)
        XCTAssert(json[1]?["name"]?.string == "other-human-name")
        XCTAssert(json[1]?["age"]?.int == 27)
    }
    
    func testSetters() throws {
        let person: Person? = Person(name: "human-name", age: 25)
        var json = JSON()
        try! json.set("person", person)
        // try! json.set("persons", [person])
        print(json)
    }
    
    func testGetters() throws {
        var json = JSON()
        
        try json.set("people", [
            ["name": "Albert", "age": 92],
            ["name": "Gertrude", "age": 109]
        ])
        
        let people: [Person] = try! json.get("people")
        XCTAssertEqual(people.count, 2)
        
        for person in people {
            print(person.name)
        }
    }

}
