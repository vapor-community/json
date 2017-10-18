import XCTest
@testable import JSON
import Core
import Node
import Dispatch

class JSONTests: XCTestCase {
    static let allTests = [
        ("testParse", testParse),
        ("testSerialize", testSerialize),
        ("testPrettySerialize", testPrettySerialize),
        ("testStringEscaping", testStringEscaping),
        ("testSerializePerformance", testSerializePerformance),
        ("testParsePerformance", testParsePerformance),
        ("testMultiThread", testMultiThread),
        ("testSerializeFragment", testSerializeFragment),
        ("testSerializeDate", testSerializeDate),
        ("testSerializeBytes", testSerializeBytes),
        ("testSerializeQuotedString", testSerializeQuotedString),
    ]

    func testParse() throws {
        let string = "{\"double\":3.14159265358979,\"object\":{\"nested\":\"text\"},\"array\":[true,1337,\"😄\"],\"int\":42,\"bool\":false,\"string\":\"ferret 🚀\"}"
        let json = try JSON(bytes: string)

        XCTAssertEqual(json["bool"]?.bool, false)
        XCTAssertEqual(json["string"]?.string, "ferret 🚀")
        XCTAssertEqual(json["int"]?.int, 42)
        XCTAssertEqual(json["double"]?.double, 3.14159265358979)
        XCTAssertEqual(json["object", "nested"]?.string, "text")
        XCTAssertEqual(json["array", 0]?.bool, true)
        XCTAssertEqual(json["array", 1]?.int, 1337)
        XCTAssertEqual(json["array", 2]?.string, "😄")
    }

    func testSerialize() throws {
        var json = try JSON(node: [
            "null": nil,
            "bool": false,
            "string": "ferret 🚀",
            "int": 42,
            "double": 3.14159265358979,
            "object": [
                "nested": "text"
            ]
        ])
        try json.set("array", [nil, true, 1337, "😄"])

        let serialized = try json.makeBytes().makeString()
        XCTAssert(serialized.contains("\"bool\":false"))
        XCTAssert(serialized.contains("\"string\":\"ferret 🚀\""))
        XCTAssert(serialized.contains("\"int\":42"))
        XCTAssert(serialized.contains("\"double\":3.14159265358979"))
        XCTAssert(serialized.contains("\"object\":{\"nested\":\"text\"}"))
        XCTAssert(serialized.contains("\"array\":[null,true,1337,\"😄\"]"))
    }

    func testPrettySerialize() throws {

        let json = JSON(node:
            .object(
                [
                    "hello" : "world"
                ]
            )
        )
        
        let serialized = try json.serialize(prettyPrint: true).makeString()
        // JSONSerialization.data(withJSONObject: _, options: .prettyPrinted)
        // results in different spacing in OSX/Linux
        #if os(Linux)
            let expectation = "{\n  \"hello\": \"world\"\n}"
        #else
            let expectation = "{\n  \"hello\" : \"world\"\n}"
        #endif
        XCTAssertEqual(serialized, expectation)
    }

    func testStringEscaping() throws {
        let json = JSON(node: .array(["he \r\n l \t l \n o w\"o\rrld "]))
        let data = try json.serialize().makeString()
        XCTAssertEqual(data, "[\"he \\r\\n l \\t l \\n o w\\\"o\\rrld \"]")
    }

    var hugeParsed: JSON!
    var hugeSerialized: Bytes!

    override func setUp() {
        Node.fuzzy = [Node.self]
        
        var huge: [String: JSON] = [:]
        for i in 0 ... 100_000 {
            huge["double_\(i)"] = 3.14159265358979
        }

        hugeParsed = JSON.object(huge)
        hugeSerialized = try! hugeParsed.makeBytes()
    }

    func testSerializePerformance() throws {
        #if XCODE
            // debug 0.333
            // release 0.291

            // foundation 0.505 / 0.391
            measure {
                _ = try! self.hugeParsed.makeBytes()
            }
        #endif
    }

    func testParsePerformance() throws {
        #if XCODE
            // debug 0.885
            // release 0.127

            // foundation 1.060 / 0.777
            measure {
                _ = try! JSON(bytes: self.hugeSerialized)
            }
        #endif
    }

    func testMultiThread() throws {
        for _ in 1...100 {
            DispatchQueue.global().async {
                let _ = try! JSON(bytes: self.hugeSerialized)
            }
        }
    }
    
    func testSerializeFragment() throws {
        let json = JSON("foo")
        let bytes = try json.serialize()
        XCTAssertEqual(bytes.makeString(), "\"foo\"")
    }
    
    func testSerializeDate() throws {
        let date = Date(timeIntervalSince1970: 1489927411)
        let json = JSON(.date(date))
        let bytes = try json.serialize()
        XCTAssertEqual(bytes.makeString(), "\"2017-03-19T12:43:31.000Z\"")
    }
    
    func testSerializeBytes() throws {
        let input = "foo".makeBytes()
        let json = JSON(.bytes(input))
        let bytes = try json.serialize()
        XCTAssertEqual(bytes.makeString(), "\"Zm9v\"")
        let parsed = try JSON(bytes: bytes)
        XCTAssertEqual(parsed.bytes?.base64Decoded.makeString(), "foo")
    }

    func testSerializeQuotedString() throws {
        let input = "Quotes \"should\" be preserved"
        let json = JSON(.string(input))
        let bytes = try json.serialize()
        XCTAssertEqual(bytes.makeString(), "\"Quotes \\\"should\\\" be preserved\"")
    }
}
