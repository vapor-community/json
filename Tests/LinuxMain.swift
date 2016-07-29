import XCTest
@testable import JSONTestSuite

XCTMain([
     testCase(JSONTests.allTests),
     testCase(JSONPolymorphicTests.allTests),
     testCase(JSONIndexableTests.allTests)
])
