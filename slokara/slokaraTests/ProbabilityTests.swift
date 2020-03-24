@testable import slokara
import XCTest

class ProbabilityTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private let mock = Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 5)
    
    func testReturnFire() {
        let result = mock.checkAttribute(result: 0)
        XCTAssertEqual(result, AttributeType.fire)
        
        let result2 = mock.checkAttribute(result: 4)
        XCTAssertEqual(result2, AttributeType.fire)
    }
    
    func testReturnWater() {
        let result = mock.checkAttribute(result: 5)
        XCTAssertEqual(result, AttributeType.water)
        
        let result2 = mock.checkAttribute(result: 9)
        XCTAssertEqual(result2, AttributeType.water)
    }
    
    func testReturnWind() {
        let result = mock.checkAttribute(result: 10)
        XCTAssertEqual(result, AttributeType.wind)
        
        let result2 = mock.checkAttribute(result: 14)
        XCTAssertEqual(result2, AttributeType.wind)
    }
    
    func testReturnSoil() {
        let result = mock.checkAttribute(result: 15)
        XCTAssertEqual(result, AttributeType.soil)
        
        let result2 = mock.checkAttribute(result: 19)
        XCTAssertEqual(result2, AttributeType.soil)
    }
    
    func testReturnLight() {
        let result = mock.checkAttribute(result: 20)
        XCTAssertEqual(result, AttributeType.light)
        
        let result2 = mock.checkAttribute(result: 24)
        XCTAssertEqual(result2, AttributeType.light)
    }
    
    func testReturnDarkness() {
        let result = mock.checkAttribute(result: 25)
        XCTAssertEqual(result, AttributeType.darkness)
        
        let result2 = mock.checkAttribute(result: 29)
        XCTAssertEqual(result2, AttributeType.darkness)
    }
    
    func testReturnEnemy() {
        let result = mock.checkAttribute(result: 30)
        XCTAssertEqual(result, AttributeType.enemy)
        
        let result2 = mock.checkAttribute(result: 34)
        XCTAssertEqual(result2, AttributeType.enemy)
    }
}
