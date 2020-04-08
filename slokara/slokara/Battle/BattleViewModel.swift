import RxSwift
import RxCocoa

final class BattleViewModel {
    private let battleModel: BattleModelProtocol
    private let disposeBag = DisposeBag()
    
    // ここはDBから取得する
    private let reelLine = ReelLine.triple
    private var userParameter: UserParameter!
    
    private var stage: Stage! {
        didSet {
            self.backGround = Observable.just(stage.backGround)
            self.numberOfEnemy = Observable.just(stage.enemies.count)
            self.enemy = stage.enemies.first
        }
    }
    private var currentStep = 0
    private var enemy: Enemy! { didSet { currentEnemy.accept(enemy) } }
    lazy var currentEnemy = BehaviorRelay<Enemy>(value: self.stage.enemies.first!)
    var backGround: Observable<UIImage>!
    var numberOfEnemy: Observable<Int>!
   
    let reelStart: Observable<Void>
    var reelActionResults: Observable<[AttributeType]>!
    
    // プレイヤーの攻撃
    private let playerAttackRelay = PublishRelay<Int64>()
    var playerAttack: Observable<Int64> { return playerAttackRelay.asObservable() }
    
    // 次のステップに進める
    private let toNextEvent = PublishRelay<Void>()
    var toNextStep: Observable<Void> { return self.toNextEvent.asObservable() }
    
    // 敵の攻撃
    private let toEnemyEvent = PublishRelay<Void>()
    var toEnemyTurn: Observable<Void> { return self.toEnemyEvent.asObservable() }
    
    // 敵の攻撃時の数値を流しておくRelay
    private let enemyAttackPowerRelay = BehaviorRelay<Int64>(value: 0)
    var damageFromEnemy: Observable<Int64> { return self.enemyAttackPowerRelay.asObservable() }
    
    // 次の敵を表示させる
    private let startWithNewEnemyRelay = PublishRelay<Enemy>()
    var startWithNewEnemy: Observable<Enemy> { return self.startWithNewEnemyRelay.asObservable() }
    
    // ステージクリア
    private let stageClearRelay = PublishRelay<Void>()
    var stageClear: Observable<Void> { return self.stageClearRelay.asObservable() }
    
    init(screenTaped: Observable<Bool>, reelStoped: Observable<[AttributeType]>, playerAttacked: Observable<Int64>, requestNextEnemy: Observable<Void>, battleModel: BattleModelProtocol) {
        self.battleModel = battleModel

        self.reelStart = screenTaped.filter{ !$0 }.map{_ in }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.reelActionResults = screenTaped.filter{ $0 }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).map{ [unowned self] _ in
            [Probability](repeating: self.enemy.probability, count: self.reelLine.numberOfCharacter).map{prob in prob.randomElement() }
        }
        
        self.battleModel.userParameter.subscribe(onNext: { [weak self] param in
            self?.userParameter = param
            }).disposed(by: disposeBag)
        
        self.battleModel.currentStage.subscribe(onNext: { [weak self] stage in
            self?.stage = stage
        }).disposed(by: disposeBag)
        
        reelStoped.subscribe(onNext: { [weak self] results in
            self?.acceptAttack(results: results)
        }).disposed(by: disposeBag)
        
        playerAttacked.subscribe(onNext: { [weak self] power in
            self?.checkEnemyLife(damage: power)
        }).disposed(by: disposeBag)
        
        requestNextEnemy.subscribe(onNext: { [unowned self] in
            self.enemy = self.stage.enemies[self.currentStep]
            self.startWithNewEnemyRelay.accept(self.enemy)
        }).disposed(by: disposeBag)
    }
    
    private func acceptAttack(results: [AttributeType]) {
        let attackPower = calculateAttackPower(result: results, line: self.reelLine)
        self.playerAttackRelay.accept(attackPower.player)
        
        // resultsを引き回さずに済むように、ここで敵の攻撃もacceptしておく。subscribe側でtoEnemyTurnをwithLatestFromする事で任意のタイミングで受け取れる
        self.enemyAttackPowerRelay.accept(attackPower.enemy)
    }
    
    private func checkEnemyLife(damage: Int64) {
        self.enemy.hp -= damage
        if self.enemy.hp > 0 {
            self.battleModel.culcUserHp(-self.enemyAttackPowerRelay.value)
            self.toEnemyEvent.accept(())
        } else {
            guard self.currentStep < self.stage.enemies.count - 1 else { self.stageClearRelay.accept(()); return }
            self.currentStep += 1
            self.toNextEvent.accept(())
        }
    }
    
    /*
     シングルライン、ダブルラインは横ラインのみ有効
     トリプルラインは縦横斜めのラインが有効
     */
    private func calculateAttackPower(result: [AttributeType], line: ReelLine) -> (player: Int64, enemy: Int64) {
        switch line {
        case .single:
            let attacks = singleLineCalaulation(list: result)
            let player = attacks.0 - self.enemy.defense
            let enemyAttack = attacks.1 - self.userParameter.defense
            return (player > 0 ? player : 0, enemyAttack > 0 ? enemyAttack : 0)

        case .double:
            guard result.count == 6 else { assert(false, "No match reel lines"); return (0, 0) }
            let topAttack = singleLineCalaulation(list: Array(result[0...2]))
            let bottomAttack = singleLineCalaulation(list: Array(result[3...5]))
            let player = topAttack.0 + bottomAttack.0 - self.enemy.defense
            let enemyAttack = topAttack.1 + bottomAttack.1 - self.userParameter.defense
            return (player > 0 ? player : 0, enemyAttack > 0 ? enemyAttack : 0)

        case .triple:
            guard result.count == 9 else { assert(false, "No match reel lines"); return (0, 0) }
            let topAttack = singleLineCalaulation(list: Array(result[0...2]))
            let middleAttack = singleLineCalaulation(list: Array(result[3...5]))
            let bottomAttack = singleLineCalaulation(list: Array(result[6...8]))
            let leftAttack = singleLineCalaulation(list: [result[0], result[3], result[6]])
            let centerAttack = singleLineCalaulation(list: [result[1], result[4], result[7]])
            let rightAttack = singleLineCalaulation(list: [result[2], result[5], result[8]])
            let leftDiagonalAttack = singleLineCalaulation(list: [result[0], result[4], result[8]])
            let rightDiagonalAttack = singleLineCalaulation(list: [result[2], result[4], result[6]])
            let attackList = [topAttack, middleAttack, bottomAttack, leftAttack, centerAttack, rightAttack, leftDiagonalAttack, rightDiagonalAttack]
            let attacks = attackList.reduce((0, 0)) { ($0.0 + $1.0, $0.1 + $1.1) }
            let player = attacks.0 - self.enemy.defense
            let enemyAttack = attacks.1 - self.userParameter.defense
            return (player > 0 ? player : 0, enemyAttack > 0 ? enemyAttack : 0)
        }
    }
    
    /*
     有利属性は火>風>土>水>火 & 光,闇 > 火,風,土,水　有利属性に対しては攻撃力1.2倍
     不利属性は有利属性の反対で、敵防御タイプに不利属性が一つでも含まれていれば不利属性判定となる　不利属性に対しては攻撃力0.8倍
     */
    private func calculateAttribute(attacks: [Int64]) -> [Int64] {
        var attackList = attacks
        attacks.enumerated().forEach {
            guard let unfavorable = AttributeType(rawValue: $0.offset)!.unfavorable else { return }
            guard let advantageous = AttributeType(rawValue: $0.offset)!.advantageous else { return }
            if enemy.defenseType.contains(unfavorable) {
                attackList[$0.offset] = Int64(Double($0.element) * 0.8)
            } else if advantageous.filter(enemy.defenseType.contains).count > 0 {
                attackList[$0.offset] = Int64(Double($0.element) * 1.2)
            }
        }
        return attackList
    }
    
    /*
     有効ライン上に同一の絵柄が連続して2つ並んだら、該当の図柄の攻撃力がそれぞれ2倍
     有効ライン上に同一の図柄が3つ揃ったら、該当の図柄の攻撃力がそれぞれ3倍
     倍率計算後、属性計算を実行
     最終的に各ライン上の攻撃力を足し合わせて、防御力を引いた数値がダメージとなる
     例) 敵 属性:風 防御力:10
        リールライン:シングルライン
        プレイヤーの攻撃力:全属性が各5
     　　停止図柄:火火土
        攻撃:(5*2 + 5*2)*1.2 + 5*0.8 = 28
        敵に与えるダメージ:28-10 = 18
     */
    private func singleLineCalaulation(list: [AttributeType]) -> (Int64, Int64) {
        guard list.count == 3 else { assert(false, "No match reel chars"); return (0, 0) }
        var attacks = AttributeType.allCases.map {_ in Int64(0) }
        if list.isEqualOfIndex(0,1,2) {
            if list[0] == .enemy {
                return (0, self.enemy.attack * 9 - self.userParameter.defense)
            } else {
                attacks[AttributeType.allCases.firstIndex(of: list[0])!] = self.userParameter.attackPower(of: list[0]) * 9
                let playerPower = calculateAttribute(attacks: attacks).reduce(0) { $0 + $1 }
                return (playerPower, 0)
            }
        }
        list.enumerated().forEach {
            guard $0.offset > 0 else {
                attacks[AttributeType.allCases.firstIndex(of: $0.element)!] +=
                    $0.element == .enemy ? self.enemy.attack : self.userParameter.attackPower(of: $0.element)
                return
            }
            if list.isEqualOfIndex($0.offset - 1, $0.offset) {
                attacks[AttributeType.allCases.firstIndex(of: $0.element)!] +=
                    $0.element == .enemy ? self.enemy.attack * 3 : self.userParameter.attackPower(of: $0.element) * 3
            } else {
                attacks[AttributeType.allCases.firstIndex(of: $0.element)!] +=
                    $0.element == .enemy ? self.enemy.attack : self.userParameter.attackPower(of: $0.element)
            }
        }
        let enemyAttack = attacks.last!
        let playerPower = calculateAttribute(attacks: attacks.dropLast()).reduce(0) { $0 + $1 }
        return (playerPower, enemyAttack)
    }
}
