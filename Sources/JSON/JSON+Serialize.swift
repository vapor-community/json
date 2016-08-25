/**
 The MIT License (MIT)

 Copyright (c) 2016 Ethan Jackwitz

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

// MARK: - JSON.Serializer

import Core

extension JSON {
    public func serialize(
        prettyPrint: Bool = false,
        skipNull: Bool = true,
        unixNewLines: Bool = true
    ) throws -> Bytes {
        var options: Serializer.Option = []

        if prettyPrint {
            options.insert(.prettyPrint)
        }

        if !skipNull {
            options.insert(.noSkipNull)
        }

        if !unixNewLines {
            options.insert(.windowsLineEndings)
        }

        return try JSON.Serializer.serialize(_node, options: options)
    }
}

extension JSON {
    struct Serializer {
        struct Option: OptionSet {
            public init(rawValue: UInt8) { self.rawValue = rawValue }
            public let rawValue: UInt8

            /// Serialize `JSON.null` instead of skipping it
            public static let noSkipNull          = Option(rawValue: 0b0001)

            /// Serialize with formatting for user readability
            public static let prettyPrint         = Option(rawValue: 0b0010)

            /// will use windows style newlines for formatting. Boo. Implies `.prettyPrint`
            public static let windowsLineEndings  = Option(rawValue: 0b0110)
        }

        init(node: Node, options: Option = []) {
            self.skipNull = !options.contains(.noSkipNull)
            self.prettyPrint = options.contains(.prettyPrint)
            self.useWindowsLineEndings = options.contains(.windowsLineEndings)
        }

        let skipNull: Bool
        let prettyPrint: Bool
        let useWindowsLineEndings: Bool
    }
}

extension JSON.Serializer {
    static func serialize<O: TextOutputStream>(_ node: Node, to stream: inout O, options: Option) throws {
        let writer = JSON.Serializer(node: node, options: options)
        try writer.writeValue(node, to: &stream)
    }

    static func serialize(_ node: Node, options: Option = []) throws -> Bytes {
        var s = ""
        let writer = JSON.Serializer(node: node, options: options)
        try writer.writeValue(node, to: &s)
        return s.bytes
    }
}

extension JSON.Serializer {
    func writeValue<O: TextOutputStream>(_ value: Node, to stream: inout O, indentLevel: Int = 0) throws {
        switch value {
        case .array(let a):
            try writeArray(a, to: &stream, indentLevel: indentLevel)

        case .bool(let b):
            writeBool(b, to: &stream)

        case .number(let num):
            switch num {
            case .double(let d):
                try writeDouble(d, to: &stream)
            case .int(let i):
                writeInteger(i, to: &stream)
            case .uint(let ui):
                writeInteger(ui, to: &stream)
            }
        case .null where !skipNull:
            writeNull(to: &stream)

        case .string(let s):
            writeString(s, to: &stream)

        case .object(let o):
            try writeObject(o, to: &stream, indentLevel: indentLevel)

        default: break
        }
    }
}

extension JSON.Serializer {
    func writeNewlineIfNeeded<O: TextOutputStream>(to stream: inout O) {
        guard prettyPrint else { return }
        stream.write("\n")
    }

    func writeIndentIfNeeded<O: TextOutputStream>(_ indentLevel: Int, to stream: inout O) {
        guard prettyPrint else { return }

        // TODO: Look into a more effective way of adding to a string.

        for _ in 0..<indentLevel {
            stream.write("    ")
        }
    }
}

extension JSON.Serializer {

    func writeArray<O: TextOutputStream>(_ a: [Node], to stream: inout O, indentLevel: Int = 0) throws {
        if a.isEmpty {
            stream.write("[]")
            return
        }

        stream.write("[")
        writeNewlineIfNeeded(to: &stream)
        var i = 0
        var nullsFound = 0
        for v in a {
            defer { i += 1 }
            if skipNull && v == .null {
                nullsFound += 1
                continue
            }
            if i != nullsFound { // check we have seen non null values
                stream.write(",")
                writeNewlineIfNeeded(to: &stream)
            }
            writeIndentIfNeeded(indentLevel + 1, to: &stream)
            try writeValue(v, to: &stream, indentLevel: indentLevel + 1)
        }
        writeNewlineIfNeeded(to: &stream)
        writeIndentIfNeeded(indentLevel, to: &stream)
        stream.write("]")
    }

    func writeObject<O: TextOutputStream>(_ o: [String: Node], to stream: inout O, indentLevel: Int = 0) throws {
        if o.isEmpty {
            stream.write("{}")
            return
        }

        stream.write("{")
        writeNewlineIfNeeded(to: &stream)
        var i = 0
        var nullsFound = 0
        for (key, value) in o {
            defer { i += 1 }
            if skipNull && value == .null {
                nullsFound += 1
                continue
            }
            if i != nullsFound { // check we have seen non null values
                stream.write(",")
                writeNewlineIfNeeded(to: &stream)
            }
            writeIndentIfNeeded(indentLevel + 1, to: &stream)
            writeString(key, to: &stream)
            stream.write(prettyPrint ? ": " : ":")
            try writeValue(value, to: &stream, indentLevel: indentLevel + 1)
        }
        writeNewlineIfNeeded(to: &stream)
        writeIndentIfNeeded(indentLevel, to: &stream)
        stream.write("}")
    }

    func writeBool<O: TextOutputStream>(_ b: Bool, to stream: inout O) {
        switch b {
        case true:
            stream.write("true")

        case false:
            stream.write("false")
        }
    }

    func writeNull<O: TextOutputStream>(to stream: inout O) {
        stream.write("null")
    }

    func writeInteger<O: TextOutputStream>(_ ui: UInt, to stream: inout O) {
        stream.write(ui.description)
    }

    func writeInteger<O: TextOutputStream>(_ i: Int, to stream: inout O) {
        stream.write(i.description)
    }

    func writeDouble<O: TextOutputStream>(_ d: Double, to stream: inout O) throws {
        guard d.isFinite else { throw JSON.Serializer.Error.invalidNumber }
        stream.write(d.description)
    }

    func writeString<O: TextOutputStream>(_ s: String, to stream: inout O) {
        stream.write("\"")
        stream.write(s)
        stream.write("\"")
    }
}

extension JSON.Serializer {
    public enum Error: String, Swift.Error {
        case invalidNumber
    }
}
