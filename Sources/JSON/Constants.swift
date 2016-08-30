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



// json special characters
let arrayOpen: UTF8.CodeUnit = "[".utf8.first!
let objectOpen: UTF8.CodeUnit = "{".utf8.first!
let arrayClose: UTF8.CodeUnit = "]".utf8.first!
let objectClose: UTF8.CodeUnit = "}".utf8.first!
let cma: UTF8.CodeUnit = ",".utf8.first!
let colon: UTF8.CodeUnit = ":".utf8.first!
let quote: UTF8.CodeUnit = "\"".utf8.first!
let slash: UTF8.CodeUnit = "/".utf8.first!
let backslash: UTF8.CodeUnit = "\\".utf8.first!

let star: UTF8.CodeUnit = "*".utf8.first!

// whitespace characters
let spc: UTF8.CodeUnit = " ".utf8.first!
let tab: UTF8.CodeUnit = "\t".utf8.first!
let cr: UTF8.CodeUnit = "\r".utf8.first!
let newline: UTF8.CodeUnit = "\n".utf8.first!
let backspace: UTF8.CodeUnit = UTF8.CodeUnit(0x08)
let formfeed: UTF8.CodeUnit = UTF8.CodeUnit(0x0C)

// Literal characters
let n: UTF8.CodeUnit = "n".utf8.first!
let t: UTF8.CodeUnit = "t".utf8.first!
let r: UTF8.CodeUnit = "r".utf8.first!
let u: UTF8.CodeUnit = "u".utf8.first!
let f: UTF8.CodeUnit = "f".utf8.first!
let a: UTF8.CodeUnit = "a".utf8.first!
let l: UTF8.CodeUnit = "l".utf8.first!
let s: UTF8.CodeUnit = "s".utf8.first!
let e: UTF8.CodeUnit = "e".utf8.first!

let b: UTF8.CodeUnit = "b".utf8.first!

// Number characters
let E: UTF8.CodeUnit = "E".utf8.first!
let zero: UTF8.CodeUnit = "0".utf8.first!
let plus: UTF8.CodeUnit = "+".utf8.first!
let minus: UTF8.CodeUnit = "-".utf8.first!
let decimal: UTF8.CodeUnit = ".".utf8.first!
let numbers: ClosedRange<UTF8.CodeUnit> = "0".utf8.first!..."9".utf8.first!
let alphaNumericLower: ClosedRange<UTF8.CodeUnit> = "a".utf8.first!..."f".utf8.first!
let alphaNumericUpper: ClosedRange<UTF8.CodeUnit> = "A".utf8.first!..."F".utf8.first!

// Valid integer number Range
let valid64BitInteger: ClosedRange<Int64> = Int64.min...Int64.max
let validUnsigned64BitInteger: ClosedRange<UInt64> = UInt64.min...UInt64(Int64.max)

// End of here Literals
let rue: [UTF8.CodeUnit] = ["r".utf8.first!, "u".utf8.first!, "e".utf8.first!]
let alse: [UTF8.CodeUnit] = ["a".utf8.first!, "l".utf8.first!, "s".utf8.first!, "e".utf8.first!]
let ull: [UTF8.CodeUnit] = ["u".utf8.first!, "l".utf8.first!, "l".utf8.first!]
