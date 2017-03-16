import Foundation
import XCTest
@testable import JSON
import Core
import Node

@discardableResult
func perf(_ block: () throws -> Void) rethrows -> Double {
    let start = Date()
    try block()
    let end = Date()
    let time = end.timeIntervalSince(start)
    return time
}

extension StructuredData {
    /**
     Attempt to initialize a node with a foundation object.

     - warning: will default to null if unexpected value
     - parameter any: the object to create a node from
     - throws: if fails to create node.
     */
    public init(any: Any) {
        switch any {
            // If we're coming from foundation, it will be an `NSNumber`.
        //This represents double, integer, and boolean.
        case let number as Double:
            // When coming from ObjC Any, this will represent all Integer types and boolean
            self = .number(Number(number))
        // Here to catch 'Any' type, but MUST come AFTER 'Double' check for JSON fuzziness
        case let bool as Bool:
            self = .bool(bool)
        case let int as Int:
            self = .number(Number(int))
        case let uint as UInt:
            self = .number(Number(uint))
        case let string as String:
            self = .string(string)
        case let object as [String : Any]:
            self = StructuredData(any: object)
        case let array as [Any]:
            self = .array(array.map(StructuredData.init))
        case _ as NSNull:
            self = .null
        case let data as Data:
            self = .bytes(data.makeBytes())
        case let bytes as NSData:
            var raw = [UInt8](repeating: 0, count: bytes.length)
            bytes.getBytes(&raw, length: bytes.length)
            self = .bytes(raw)
        case let date as Date:
            self = .date(date)
        case let date as NSDate:
            let date = Date(timeIntervalSince1970: date.timeIntervalSince1970)
            self = .date(date)
        default:
            self = .null
        }
    }

    /**
     Initialize a node with a foundation dictionary
     - parameter any: the dictionary to initialize with
     */
    public init(any: [String: Any]) {
        var mutable: [String: StructuredData] = [:]
        any.forEach { key, val in
            mutable[key] = StructuredData(any: val)
        }
        self = .object(mutable)
    }

    /**
     Initialize a node with a foundation array
     - parameter any: the array to initialize with
     */
    public init(any: [Any]) {
        let array = any.map(StructuredData.init)
        self = .array(array)
    }

    /**
     Create an any representation of the node,
     intended for Foundation environments.
     */
    public var any: Any {
        switch self {
        case .object(let ob):
            var mapped: [String : Any] = [:]
            ob.forEach { key, val in
                mapped[key] = val.any
            }
            return mapped
        case .array(let array):
            return array.map { $0.any }
        case .bool(let bool):
            return bool
        case .number(let number):
            return number.double
        case .string(let string):
            return string
        case .null:
            return NSNull()
        case .bytes(let bytes):
            var bytes = bytes
            let data = NSData(bytes: &bytes, length: bytes.count)
            return data
        case .date(let date):
            return date
        }
    }
}

class CompareTests: XCTestCase {
    static let allTests = [
        ("testJayPerformance", testJayPerformance),
        ("testFoundationPerformance", testFoundationPerformance),
    ]

    let rawFile: Bytes = {
        let mockJSON = #file.components(separatedBy: "JSONTests")[0] + "JSONTests/MOCK_DATA.json"
        let rawFile = try! DataFile.load(path: mockJSON)
        return rawFile
    }()

    func testJayPerformance() throws {
        var structure: StructuredData = .object([:])
        let time = try perf {
            let json = try JSON(bytes: rawFile)
            structure = json.wrapped
        }
        print("First: \(structure.array!.first!)")
        print("It took Jay \(time) seconds")
    }

    func testFoundationPerformance() throws {
        var structure: StructuredData = .object([:])
        let time = try perf {
            let data = Data(bytes: rawFile)
            let blob = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            structure = StructuredData(any: blob)
        }
        print("First: \(structure.array!.first!)")
        print("It took Foundation \(time) seconds")
    }
}

class JSONTests: XCTestCase {
    static let allTests = [
        ("testParse", testParse),
        ("testSerialize", testSerialize),
        ("testComments", testComments),
        ("testCommentsSingle", testCommentsSingle),
        ("testCommentsInternal", testCommentsInternal),
        ("testCrazyCommentInternal", testCrazyCommentInternal),
        ("testSerializePerformance", testSerializePerformance),
        ("testParsePerformance", testParsePerformance),
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
        let json = try JSON(node: [
            "null": nil,
            "bool": false,
            "string": "ferret 🚀",
            "int": 42,
            "double": 3.14159265358979,
            "object": JSON(node: [
                "nested": "text"
            ]),
            "array": JSON(node: [nil, true, 1337, "😄"])
        ])

        let serialized = try json.makeBytes().string
        XCTAssert(serialized.contains("\"bool\":false"))
        XCTAssert(serialized.contains("\"string\":\"ferret 🚀\""))
        XCTAssert(serialized.contains("\"int\":42"))
        XCTAssert(serialized.contains("\"double\":3.14159265358979"))
        XCTAssert(serialized.contains("\"object\":{\"nested\":\"text\"}"))
        XCTAssert(serialized.contains("\"array\":[null,true,1337,\"😄\"]"))
    }

    func testComments() throws {
        let string = " /* asdfg */ {\"1\":1}"
        do {
            let parsed = try JSON(serialized: string, allowComments: true)
            XCTAssertEqual(parsed["1"]?.int, 1)
        } catch {
            XCTFail("Could not parse: \(error)")
        }
    }

    func testCommentsSingle() throws {
        let string = " {\"1\":1 // test \n }"
        do {
            let parsed = try JSON(serialized: string, allowComments: true)
            XCTAssertEqual(parsed["1"]?.int, 1)
        } catch {
            XCTFail("Could not parse: \(error)")
        }
    }

    func testCommentsInternal() throws {
        let string = " {\"1\":\"/* comment */\"}"
        do {
            let parsed = try JSON(serialized: string, allowComments: true)
            XCTAssertEqual(parsed["1"]?.string, "/* comment */")
        } catch {
            XCTFail("Could not parse: \(error)")
        }
    }

    func testCrazyCommentInternal() throws {
        let string = "{\"1\": \"Here's a great comment quote \\\"/*why are people doing this*/\\\"\"}"
        do {
            let parsed = try JSON(serialized: string, allowComments: true)
            XCTAssertEqual(parsed["1"]?.string, "Here's a great comment quote \"/*why are people doing this*/\"")
        } catch {
            XCTFail("Could not parse: \(error)")
        }
    }

    func testPrettySerialize() throws {
        let json = try JSON(node: [
            "hello": "world"
        ])

        let serialized = try json.serialize(prettyPrint: true).string
        XCTAssertEqual(serialized, "{\n    \"hello\": \"world\"\n}")
    }

    func testStringEscaping() throws {
        let json = try JSON(node: ["he \r\n l \t l \n o w\"o\rrld "])
        let data = try json.serialize().string
        XCTAssertEqual(data, "[\"he \\r\\n l \\t l \\n o w\\\"o\\rrld \"]")
    }

    var hugeParsed: JSON!
    var hugeSerialized: Bytes!

    override func setUp() {
        var huge: [String: Node] = [:]
        for i in 0 ... 100_000 {
            huge["double_\(i)"] = 3.14159265358979
        }

        hugeParsed = try! JSON(node: huge)
        hugeSerialized = try! hugeParsed.makeBytes()
    }

    func testSerializePerformance() throws {
        // debug 0.333
        // release 0.291

        // foundation 0.505 / 0.391
        measure {
            _ = try! self.hugeParsed.makeBytes()
        }
    }

    func testParsePerformance() throws {
        // debug 0.885
        // release 0.127

        // foundation 1.060 / 0.777
        measure {
            _ = try! JSON(bytes: self.hugeSerialized)
        }
    }

}
