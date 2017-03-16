#if os(Linux)
import XCTest
@testable import JSONTests

XCTMain([
    testCase(CompareTests.allTests),
    testCase(JSONTests.allTests),
    testCase(JSONConvertibleTests.allTests)
])
#endif
