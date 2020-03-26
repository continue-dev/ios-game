import RxSwift

protocol BattleModelProtocol {
    var currentStage: Observable<Stage> { get }
    var userParameter: Observable<UserParameter> { get }
}

final class BattleModelImpl: BattleModelProtocol {
    
    private let stage: Stage
        
    init(stageId: Int) {
        // TODO: 正規実装ではstageIdをもとにStageを取得する
        self.stage = Stage(id: 0, backGround: UIImage(named: "background_sample")!, enemies: [
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], image: UIImage(named: "enemy_sample_small")!, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 10)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], image: UIImage(named: "enemy_sample_small")!, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 10)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], image: UIImage(named: "enemy_sample_small")!, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 15)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], image: UIImage(named: "enemy_sample_small")!, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 15)),
            Enemy(id: 0, name: "big", hp: 300, attack: 30, defense: 50, attackType: [.wind], defenseType: [.wind], image: UIImage(named: "enemy_sample_big")!, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 30))
        ])
    }
    
    var currentStage: Observable<Stage> {
        return Observable.just(self.stage)
    }
    
    var userParameter: Observable<UserParameter> {
        return Observable.just(UserParameter(fireAttack: 5, waterAttack: 5, windAttack: 5, soilAttack: 5, lightAttack: 5, darknessAttack: 10, defense: 20, maxHp: 100))
    }
}
