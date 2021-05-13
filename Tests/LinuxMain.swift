import XCTest

import async_awaitTests

var tests = [XCTestCaseEntry]()
tests += async_awaitTests.allTests()
XCTMain(tests)
