import XCTest
@testable import slokara

class ReelTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testSingleLine() {
        let reel = Reel(top: [false, false, false], center: [false, false, false], bottom: [true, true, true])
        XCTAssertEqual(reel.lines, ReelLine.single)
    }
    
    func testDoubleLine() {
        let reel = Reel(top: [false, false, false], center: [true, false, false], bottom: [true, true, true])
        XCTAssertEqual(reel.lines, ReelLine.double)
    }
    
    func testDoubleLineFull() {
        let reel = Reel(top: [false, false, false], center: [true, true, true], bottom: [true, true, true])
        XCTAssertEqual(reel.lines, ReelLine.double)
    }
    
    func testTripleLine() {
        let reel = Reel(top: [false, true, false], center: [true, false, false], bottom: [true, true, true])
        XCTAssertEqual(reel.lines, ReelLine.triple)
    }
    
    func testTripleLineFull() {
        let reel = Reel(top: [true, true, true], center: [true, true, true], bottom: [true, true, true])
        XCTAssertEqual(reel.lines, ReelLine.triple)
    }
    
    func testEnableLineMin() {
        let enableLines = Reel(top: [true, true, true], center: [false, false, false], bottom: [false, false, false]).enableLines
        let result = [[true, true, true]]
        XCTAssertEqual(enableLines, result)
    }
    
    func testEnableLineDoublea() {
        let enableLines = Reel(top: [true, true, true], center: [true, false, false], bottom: [false, false, false]).enableLines
        let result = [[true, true, true], [true, false, false]]
        XCTAssertEqual(enableLines, result)
    }
    
    func testEnableLineDouble2() {
        let enableLines = Reel(top: [true, true, true], center: [true, true, true], bottom: [false, false, false]).enableLines
        let result = [[true, true, true], [true, true, true]]
        XCTAssertEqual(enableLines, result)
    }
    
    func testEnableLineDouble3() {
        let enableLines = Reel(top: [false, true, false], center: [true, true, true], bottom: [false, false, false]).enableLines
        let result = [[false, true, false], [true, true, true]]
        XCTAssertEqual(enableLines, result)
    }
    
    func testEnableLineTriple() {
        let enableLines = Reel(top: [true, true, true], center: [true, true, false], bottom: [true, false, false]).enableLines
        let result = [[true, true, true], [true, true, false], [true, false, false]]
        XCTAssertEqual(enableLines, result)
    }
}
