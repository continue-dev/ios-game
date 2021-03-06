import RxSwift
import RxCocoa

final class BattleViewModel {
    private let battleModel: BattleModelProtocol
    private let disposeBag = DisposeBag()
    
    var reel: Reel!
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
    var reelActionResults: Observable<[AttributeType?]>!
    
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
    
    // オートプレイ
    private let autoPlayRelay = PublishRelay<Bool>()
    var isAutoPlay: Observable<Bool> { return self.autoPlayRelay.asObservable() }
    
    init(screenTaped: Observable<Bool>, reelStoped: Observable<[AttributeType?]>, setAutoPlay: Observable<Bool>, playerAttacked: Observable<Int64>, requestNextEnemy: Observable<Void>, battleModel: BattleModelProtocol) {
        self.battleModel = battleModel

        self.reelStart = screenTaped.filter{ !$0 }.map{_ in }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance)
        
        self.reelActionResults = screenTaped.filter{ $0 }.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).map{ [unowned self] _ in
            self.reel.enableLines.flatMap{ $0 }.map{ $0 ? self.enemy.probability.randomElement() : nil }
        }
        
        self.battleModel.userParameter.subscribe(onNext: { [weak self] param in
            self?.userParameter = param
            }).disposed(by: disposeBag)
        
        self.battleModel.currentStage.subscribe(onNext: { [weak self] stage in
            self?.stage = stage
        }).disposed(by: disposeBag)
        
        self.battleModel.reelStatus.subscribe(onNext: { [weak self] reel in
            self?.reel = reel
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
        
        setAutoPlay.bind(to: self.autoPlayRelay).disposed(by: disposeBag)
    }
    
    private func acceptAttack(results: [AttributeType?]) {
        let attackPower = calculateAttackPower(result: results, line: self.reel.lines)
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
     縦、横、斜めの2つ以上連続して並んでいるラインが有効ライン
     */
    private func calculateAttackPower(result: [AttributeType?], line: ReelLine) -> (player: Int64, enemy: Int64) {
        guard result.count.isMultiple(of: 3) else { assert(false, "No Match charactors."); return (0, 0) }
        
        // 計算メソッドでのOutOfIndexを避ける為、リールの不足分をnil埋めする
        var result = result
        while result.count < 9 {
            result.append(nil)
        }
        
        let chars = result.separate(of: 3)

        let topAttack = singleLineCalaulation(list: chars[0])
        let middleAttack = singleLineCalaulation(list: chars[1])
        let bottomAttack = singleLineCalaulation(list: chars[2])
        let leftAttack = singleLineCalaulation(list: [chars[0][0], chars[1][0], chars[2][0]])
        let centerAttack = singleLineCalaulation(list: [chars[0][1], chars[1][1], chars[2][1]])
        let rightAttack = singleLineCalaulation(list: [chars[0][2], chars[1][2], chars[2][2]])
        let leftDiagonalAttack = singleLineCalaulation(list: [chars[0][0], chars[1][1], chars[2][2]])
        let rightDiagonalAttack = singleLineCalaulation(list: [chars[0][2], chars[1][1], chars[2][0]])
        let attackList = [topAttack, middleAttack, bottomAttack, leftAttack, centerAttack, rightAttack, leftDiagonalAttack, rightDiagonalAttack]
        let attacks = attackList.reduce((0, 0)) { ($0.0 + $1.0, $0.1 + $1.1) }
        let player = attacks.0 - self.enemy.defense
        let enemyAttack = applyEnemyAttributeType(enemyAttack: attacks.1) - self.userParameter.defense

        return (player > 0 ? player : 0, enemyAttack > 0 ? enemyAttack : 0)
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
     敵の攻撃に属性をつけ、プレイヤーの属性を参照して敵の攻撃を算出する
     */
    private func applyEnemyAttributeType(enemyAttack: Int64) -> Int64 {
        guard let enemyAttackType = enemy.attackType.randomElement() else { return enemyAttack }
        guard !userParameter.defenseType.isEmpty else { return enemyAttack }
        
        if userParameter.defenseType.contains(enemyAttackType.unfavorable!) {
            return Int64(Double(enemyAttack) * 0.8)
        } else if enemyAttackType.advantageous!.filter(userParameter.defenseType.contains).count > 0 {
            return Int64(Double(enemyAttack) * 1.2)
        }
        return enemyAttack
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
    private func singleLineCalaulation(list: [AttributeType?]) -> (Int64, Int64) {
        guard list.count == 3 else { assert(false, "No match reel chars"); return (0, 0) }
        // ラインの真ん中がnil、または2つ以上がnilなら無効ライン
        guard list.filter({ $0 == nil }).count < 2 , list[1] != nil else { return (0, 0) }
        
        var attacks = AttributeType.allCases.map {_ in Int64(0) }
        if list.isEqualOfIndex(0,1,2) {
            if list[0] == .enemy {
                return (0, self.enemy.attack * 9 - self.userParameter.defense)
            } else {
                attacks[AttributeType.allCases.firstIndex(of: list[0]!)!] = self.userParameter.attackPower(of: list[0]!) * 9
                let playerPower = calculateAttribute(attacks: attacks).reduce(0) { $0 + $1 }
                return (playerPower, 0)
            }
        }
        list.enumerated().forEach {
            guard let item = $0.element else { return }
            guard $0.offset > 0 else {
                attacks[AttributeType.allCases.firstIndex(of: item)!] +=
                    $0.element == .enemy ? self.enemy.attack : self.userParameter.attackPower(of: item)
                return
            }
            if list.isEqualOfIndex($0.offset - 1, $0.offset) {
                attacks[AttributeType.allCases.firstIndex(of: item)!] +=
                    $0.element == .enemy ? self.enemy.attack * 3 : self.userParameter.attackPower(of: item) * 3
            } else {
                attacks[AttributeType.allCases.firstIndex(of: item)!] +=
                    $0.element == .enemy ? self.enemy.attack : self.userParameter.attackPower(of: item)
            }
        }
        let enemyAttack = attacks.last!
        let playerPower = calculateAttribute(attacks: attacks.dropLast()).reduce(0) { $0 + $1 }
        return (playerPower, enemyAttack)
    }
}
