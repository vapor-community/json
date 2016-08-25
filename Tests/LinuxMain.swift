#if os(Linux)
import XCTest
@testable import JSONTests

XCTMain([
     testCase(JSONTests.allTests),
     testCase(JSONConvertibleTests.allTests)
])
#endif
