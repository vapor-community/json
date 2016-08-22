#if os(Linux)
import XCTest
@testable import JSONTests

XCTMain([
     testCase(JSONTests.allTests),
     testCase(JSONPolymorphicTests.allTests),
     testCase(JSONIndexableTests.allTests),
     testCase(JSONConvertibleTests.allTests)
])
#endif
