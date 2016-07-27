import XCTest
@testable import JSON

class JSONIndexableTests: XCTestCase {
    static let allTests = [
        ("testInt", testInt),
        ("testString", testString),
        ("testStringSequenceObject", testStringSequenceObject),
        ("testStringSequenceArray", testStringSequenceArray),
        ("testIntSequence", testIntSequence),
        ("testMixed", testMixed),
        ]

    func testInt() throws {
        let array = try JSON(["one",
                              "two",
                              "three"])
        XCTAssert(array[1]?.string == "two")
    }

    func testString() throws {
        let object = try JSON(["a" : 1])
        XCTAssert(object["a"]?.int == 1)
    }

    func testStringSequenceObject() throws {
        let ob = try JSON(with: ["key" : ["path" : "found me!"]])
        XCTAssert(ob["key", "path"]?.string == "found me!")
    }

    func testStringSequenceArray() throws {
        let obArray = try JSON(with: [["a" : 0],
                                      ["a" : 1],
                                      ["a" : 2],
                                      ["a" : 3]])
        let collection = obArray["a"]?.array?.flatMap { $0.int } ?? []
        XCTAssert(collection == [0,1,2,3])
    }

    func testIntSequence() throws {
        let inner = try JSON(with: ["...",
                                    "found me!"])
        let outer = JSON.array([inner])
        XCTAssert(outer[0, 1]?.string == "found me!")
    }

    func testMixed() throws {
        let mixed = try JSON(with: ["one" : ["a", "b", "c"]])
        XCTAssert(mixed["one", 1]?.string == "b")
    }
}
