import RxSwift
import RealmSwift

protocol BattleModelProtocol {
    var currentStage: Observable<Stage> { get }
    var userParameter: Observable<UserParameter> { get }
    var reelStatus: Observable<Reel> { get }
    func culcUserHp(_ value: Int64)
}

final class BattleModelImpl: BattleModelProtocol {
    
    private let stage: Stage
        
    init(stageId: Int) {
        #if !PROD
        let ud = UserDefaults.standard
        if ud.bool(forKey: "tuningMode"), let data = ud.data(forKey: "editedStage") {
            guard let stage =  try? JSONDecoder().decode(Stage.self, from: data) else { fatalError("Stage decode failed.") }
            self.stage = stage
            return
        }
        #endif
        
        // TODO: 正規実装ではstageIdをもとにStageを取得する
        self.stage = Stage(id: 0, backGroundName: "background_sample", enemies: [
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], imageName: "enemy_sample_small", type: .small, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 10)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], imageName: "enemy_sample_small", type: .small, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 10)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], imageName: "enemy_sample_small", type: .small, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 15)),
            Enemy(id: 0, name: "small", hp: 100, attack: 10, defense: 20, attackType: [.wind], defenseType: [.wind], imageName: "enemy_sample_small", type: .small, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 15)),
            Enemy(id: 0, name: "big", hp: 300, attack: 30, defense: 50, attackType: [.wind], defenseType: [.wind], imageName:  "enemy_sample_big", type: .big, probability: Probability(fire: 5, water: 5, wind: 5, soil: 5, light: 5, darkness: 5, enemy: 30))
        ])
    }
    
    var currentStage: Observable<Stage> {
        return Observable.just(self.stage)
    }
    
    var userParameter: Observable<UserParameter> {
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode"), let data = UserDefaults.standard.data(forKey: "userParameter") {
            guard let param = try? JSONDecoder().decode(UserParameter.self, from: data) else { fatalError("UserParameter decode failed.") }
            return Observable.just(param)
        }
        #endif
        
        return Observable.just(UserParameter(fireAttack: 5, waterAttack: 5, windAttack: 5, soilAttack: 5, lightAttack: 5, darknessAttack: 10, maxHp: 100, defenseType: []))
    }
    
    var reelStatus: Observable<Reel> {
        #if !PROD
        if UserDefaults.standard.bool(forKey: "tuningMode") {
            if let json = UserDefaults.standard.data(forKey: "reel") {
                guard let reel = try? JSONDecoder().decode(Reel.self, from: json) else { fatalError("Reel decode failed.") }
                return Observable.just(reel)
            }
        }
        #endif
        
        return Observable.just(Reel(top: [true, true, true], center: [false, true, true], bottom: [true, false, true]))
    }
    
    func culcUserHp(_ value: Int64) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした"); return }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "UserStatusを読み込めませんでした"); return }
        let newValue = status.currentHp + value >= status.maxHp ? status.maxHp : status.currentHp + value
        try! realm.write {
            status.currentHp = newValue > 0 ? newValue : 0
        }
    }
}
