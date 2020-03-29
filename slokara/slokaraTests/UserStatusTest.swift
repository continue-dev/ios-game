import XCTest
@testable import slokara


class UserStatusTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWoodRankUp() {
        let mock = UserStatus()
        mock.grade = .wood
        mock.rankValue = 1
        
        XCTAssertEqual(mock.grade, Grade.wood)
        XCTAssertEqual(mock.rankValue, 1)
        
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.wood)
        XCTAssertEqual(mock.rankValue, 2)

        mock.rankValue = 3
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.stone)
        XCTAssertEqual(mock.rankValue, 1)
    }
    
    func testStoneRankUp() {
        let mock = UserStatus()
        mock.grade = .stone
        mock.rankValue = 1
        
        XCTAssertEqual(mock.grade, Grade.stone)
        XCTAssertEqual(mock.rankValue, 1)
        
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.stone)
        XCTAssertEqual(mock.rankValue, 2)
        
        mock.rankValue = 3
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.copper)
        XCTAssertEqual(mock.rankValue, 4)
    }
    
    func testCopperRankUp() {
        let mock = UserStatus()
        mock.grade = .copper
        mock.rankValue = 4
        
        XCTAssertEqual(mock.grade, Grade.copper)
        XCTAssertEqual(mock.rankValue, 4)
        
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.copper)
        XCTAssertEqual(mock.rankValue, 5)
        
        mock.rankValue = 6
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.silver)
        XCTAssertEqual(mock.rankValue, 1)
    }
    
    func testSilverRankUp() {
        let mock = UserStatus()
        mock.grade = .silver
        mock.rankValue = 1
        
        XCTAssertEqual(mock.grade, Grade.silver)
        XCTAssertEqual(mock.rankValue, 1)
        
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.silver)
        XCTAssertEqual(mock.rankValue, 2)
        
        mock.rankValue = 3
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.gold)
        XCTAssertEqual(mock.rankValue, 1)
    }
    
    func testGoldRankUp() {
        let mock = UserStatus()
        mock.grade = .gold
        mock.rankValue = 1
        
        XCTAssertEqual(mock.grade, Grade.gold)
        XCTAssertEqual(mock.rankValue, 1)
        
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.gold)
        XCTAssertEqual(mock.rankValue, 2)
        
        mock.rankValue = 3
        mock.rankUp()
        
        XCTAssertEqual(mock.grade, Grade.gold)
        XCTAssertEqual(mock.rankValue, 3)
    }
}
