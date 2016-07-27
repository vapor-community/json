import XCTest
@testable import JSON
import Core

class JSONTests: XCTestCase {
    static let allTests = [
        ("testSimple", testSimple),
        ("testComplex", testComplex),
        ("testBytesConversion", testBytesConversion),
        ("testDoubleCast", testDoubleCast),
        ("testUInt", testUInt),
        ("testEquatable", testEquatable)
    ]

    func testSimple() throws {
        let string = "{\"hello\":\"world\"}"
        let json = try JSON(bytes: string.bytes)

        let expected = try JSON(["hello": "world"])
        XCTAssertEqual(json, expected)

        XCTAssertEqual(try expected.makeBytes(), string.bytes)
    }

    func testComplex() throws {
        let json = try JSON([
            "null": nil,
            "bool": false,
            "string": "ferret 🚀",
            "int": 42,
            "double": 3.14159265358979,
            "object": JSON([
                "nested": "text"
            ]),
            "array": JSON([nil, true, 1337, "😄"])
        ])

        #if os(Linux)
            let serialized = "{\"bool\":0,\"int\":42,\"null\":null,\"string\":\"ferret 🚀\",\"double\":3.14159265358979,\"array\":[null,1,1337,\"😄\"],\"object\":{\"nested\":\"text\"}}"
        #else
            let serialized = "{\"double\":3.14159265358979,\"object\":{\"nested\":\"text\"},\"int\":42,\"string\":\"ferret 🚀\",\"null\":null,\"bool\":false,\"array\":[null,true,1337,\"😄\"]}"
        #endif

        XCTAssertEqual(
            try json.makeBytes().string,
            serialized
        )

        XCTAssertEqual(
            try JSON(bytes: serialized.bytes),
            json
        )
    }

    func testBytesConversion() throws {
        let string = "hello world"
        let bytes = Node(bytes: string.bytes)
        let js = try JSON(bytes)
        XCTAssert(js.string == string.bytes.base64String)
    }

    func testDoubleCast() throws {
        let jsonString = "{\"double\":3.14159}"
        let json = try JSON(bytes: jsonString.bytes)
        XCTAssert(json["double"]?.double == 3.14159)
    }

    func testUInt() throws {
        let json = try JSON(["uint": UInt(259_772)])
        let serialized = try json.makeBytes()
        print("Seri: \(serialized.string)")
        XCTAssert(serialized.string == "{\"uint\":259772}")
    }

    func testEquatable() throws {
        let truthyPairs: [(JSON, JSON)] = [
            (.null, .null),
            (.number(1), .number(1.0)),
            (.bool(true), .bool(true)),
            (.bool(true), .number(1.0)),
            (.number(1), .bool(true)),
            (.bool(false), .bool(false)),
            (.string("hello"), .string("hello")),
            (try JSON([1,2,3]), try JSON([1,2,3])),
            (try JSON(["key": "value"]), try JSON(["key": "value"]))
        ]

        truthyPairs.forEach { lhs, rhs in XCTAssert(lhs == rhs, "\(lhs) should equal \(rhs)") }

        let falsyPairs: [(JSON, JSON)] = [
            (.null, .number(42)),
            (.number(1), .string("hello")),
            (.bool(true), try JSON(["key": "value"])),
            (try JSON([1,2,3]), .bool(false)),
            (.string("hello"), .string("goodbye")),
            (try JSON([1,2,3]), try JSON([1,2,3,4])),
            (try JSON(["key": "value"]), try JSON(["array", "of", "strings"]))
        ]

        falsyPairs.forEach { lhs, rhs in XCTAssert(lhs != rhs, "\(lhs) should equal \(rhs)") }
    }
}
