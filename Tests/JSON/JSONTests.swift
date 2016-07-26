import XCTest
@testable import JSON
import Core

class JSONTests: XCTestCase {
    static var allTests = [
        ("testSimple", testSimple),
        ("testComplex", testComplex),
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
            let serialized = "(\"{\"bool\":0,\"int\":42,\"null\":null,\"string\":\"ferret 🚀\",\"double\":3.14159265358979,\"array\":[null,1,1337,\"😄\"],\"object\":{\"nested\":\"text\"}}\")"
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
}
