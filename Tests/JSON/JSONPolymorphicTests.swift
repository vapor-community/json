import XCTest
@testable import JSON

class JSONPolymorphicTests: XCTestCase {
    static let allTests = [
        ("testPolymorphicString", testPolymorphicString),
        ("testPolymorphicInt", testPolymorphicInt),
        ("testPolymorphicUInt", testPolymorphicUInt),
        ("testPolymorphicFloat", testPolymorphicFloat),
        ("testPolymorphicDouble", testPolymorphicDouble),
        ("testPolymorphicNull", testPolymorphicNull),
        ("testPolymorphicBool", testPolymorphicBool),
        ("testPolymorphicArray", testPolymorphicArray),
        ("testPolymorphicObject", testPolymorphicObject)
    ]

    func testPolymorphicString() throws {
        let bool: JSON = .bool(true)
        let int: JSON = .number(1)
        let double: JSON = .number(3.14)
        let string: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(bool.string == "true")
        XCTAssert(int.string == "1")
        XCTAssert(double.string == "3.14")
        XCTAssert(string.string == "hi")
        XCTAssertNil(ob.string)
        XCTAssertNil(arr.string)
    }

    func testPolymorphicInt() throws {
        let boolTrue: JSON = .bool(true)
        let boolFalse: JSON = .bool(false)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let intString: JSON = .string("123")

        let histring: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(boolTrue.int == 1)
        XCTAssert(boolFalse.int == 0)
        XCTAssert(int.int == 42)
        XCTAssert(double.int == 3)
        XCTAssert(intString.int == 123)
        XCTAssertNil(histring.int)
        XCTAssertNil(ob.int)
        XCTAssertNil(arr.int)
    }

    func testPolymorphicUInt() throws {
        let boolTrue: JSON = .bool(true)
        let boolFalse: JSON = .bool(false)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let intString: JSON = .string("123")

        let histring: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(boolTrue.uint == 1)
        XCTAssert(boolFalse.uint == 0)
        XCTAssert(int.uint == 42)
        XCTAssert(double.uint == 3)
        XCTAssert(intString.uint == 123)
        XCTAssertNil(histring.uint)
        XCTAssertNil(ob.uint)
        XCTAssertNil(arr.uint)
    }

    func testPolymorphicFloat() throws {
        let boolTrue: JSON = .bool(true)
        let boolFalse: JSON = .bool(false)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let intString: JSON = .string("123")
        let doubleString: JSON = .string("42.5997")

        let histring: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(boolTrue.float == 1)
        XCTAssert(boolFalse.float == 0)
        XCTAssert(int.float == 42)
        XCTAssert(double.float == 3.14)
        XCTAssert(intString.float == 123)
        XCTAssert(doubleString.float == 42.5997)
        XCTAssertNil(histring.float)
        XCTAssertNil(ob.float)
        XCTAssertNil(arr.float)
    }

    func testPolymorphicDouble() throws {
        let boolTrue: JSON = .bool(true)
        let boolFalse: JSON = .bool(false)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let intString: JSON = .string("123")
        let doubleString: JSON = .string("42.5997")

        let histring: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(boolTrue.double == 1)
        XCTAssert(boolFalse.double == 0)
        XCTAssert(int.double == 42)
        XCTAssert(double.double == 3.14)
        XCTAssert(intString.double == 123)
        XCTAssert(doubleString.double == 42.5997)
        XCTAssertNil(histring.double)
        XCTAssertNil(ob.double)
        XCTAssertNil(arr.double)
    }

    func testPolymorphicNull() throws {
        let null: JSON = .null
        let lowerNullString: JSON = .string("null")
        let upperNullString: JSON = .string("NULL")

        let bool: JSON = .bool(true)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let string: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssertTrue(null.isNull)
        XCTAssertTrue(lowerNullString.isNull)
        XCTAssertTrue(upperNullString.isNull)

        XCTAssertFalse(bool.isNull)
        XCTAssertFalse(int.isNull)
        XCTAssertFalse(double.isNull)
        XCTAssertFalse(string.isNull)
        XCTAssertFalse(ob.isNull)
        XCTAssertFalse(arr.isNull)
    }

    func testPolymorphicBool() throws {
        let null: JSON = .null
        let bool: JSON = .bool(true)
        let int: JSON = .number(42)
        let boolInt: JSON = .number(1)
        let double: JSON = .number(3.14)
        let boolDouble: JSON = .number(1.0)
        let string: JSON = .string("hi")
        let boolString: JSON = .string("true")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssert(null.bool == false)
        XCTAssert(bool.bool == true)
        XCTAssertNil(int.bool)
        XCTAssert(boolInt.bool == true)
        XCTAssertNil(double.bool)
        XCTAssert(boolDouble.bool == true)
        XCTAssertNil(string.bool)
        XCTAssert(boolString.bool == true)
        XCTAssertNil(ob.bool)
        XCTAssertNil(arr.bool)
    }

    func testPolymorphicArray() throws {
        let null: JSON = .null
        let bool: JSON = .bool(true)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let string: JSON = .string("hi")
        let arrayString: JSON = .string("hi, there, array")
        let ob: JSON = .object(["key": .string("value")])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssertNil(null.array)
        XCTAssertNil(bool.array)
        XCTAssertNil(int.array)
        XCTAssertNil(double.array)

        let single = string.array?.flatMap { $0.string } ?? []
        XCTAssert(single == ["hi"])
        let fetched = arrayString.array?.flatMap { $0.string } ?? []
        XCTAssert(fetched == ["hi", "there", "array"])
        let array = arr.array?.flatMap { $0.int } ?? []
        XCTAssert(array == [1, 2, 3])

        XCTAssertNil(ob.array)
    }

    func testPolymorphicObject() throws {
        let null: JSON = .null
        let bool: JSON = .bool(true)
        let int: JSON = .number(42)
        let double: JSON = .number(3.14)
        let string: JSON = .string("hi")
        let ob: JSON = try JSON(node: ["key": "value"])
        let arr: JSON = try JSON(node: [1,2,3])

        XCTAssertNotNil(ob.object)
        XCTAssert(ob.object?["key"]?.string == "value")

        XCTAssertNil(null.object)
        XCTAssertNil(bool.object)
        XCTAssertNil(int.object)
        XCTAssertNil(double.object)
        XCTAssertNil(string.object)
        XCTAssertNil(arr.object)
        
    }
}
