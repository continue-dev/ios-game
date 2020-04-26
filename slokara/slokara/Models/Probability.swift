import Foundation

struct Probability: Codable {
    let fire: Int
    let water: Int
    let wind: Int
    let soil: Int
    let light: Int
    let darkness: Int
    let enemy: Int
    
    func randomElement() -> AttributeType {
        let nums = [fire, water, wind, soil, light, darkness, enemy]
        let sam = nums.reduce(0) { $0 + $1 }
        let result = Int.random(in: 0..<sam)
        return checkAttribute(result: result)
    }
    
    func checkAttribute(result: Int) -> AttributeType {
        let nums = [fire, water, wind, soil, light, darkness, enemy]
        var result = result
        var returnIndex = 0
        for num in nums {
            result -= num
            guard result >= 0 else { break }
            returnIndex += 1
        }
        return AttributeType.allCases[returnIndex]
    }
}
