import XCTest
@testable import slokara

class Array_Test: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    private let list = ["A", "A", "B", "A", "C"]

    func testEqualIndexes() {
        XCTAssertTrue(list.isEqualOfIndex(0, 1))
        XCTAssertTrue(list.isEqualOfIndex(0, 3))
        XCTAssertTrue(list.isEqualOfIndex(0, 1, 3))
    }
    
    func testNotEqualIndexes() {
        XCTAssertFalse(list.isEqualOfIndex(0, 2))
        XCTAssertFalse(list.isEqualOfIndex(0, 4))
        XCTAssertFalse(list.isEqualOfIndex(0, 1, 2))
    }

}
