import Foundation
import RxSwift
import RealmSwift

protocol ItemShopModelProtocol {
    var itemList: Observable<[Item]> { get }
    var possessionItemList: Observable<[Int: Int]> { get }
    var currentCoins: Observable<Int> { get }
    func savePossessionItemList(list: [Int: Int])
    func saveFutureCoins(_ coins: Int)
}

final class ItemShopModelImpl: ItemShopModelProtocol {
    var itemList: Observable<[Item]> {
        return Observable.just(getItems())
    }
    var possessionItemList: Observable<[Int : Int]> {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        let list = realm.objects(ItemPossession.self)
        if list.isEmpty {
            return Observable.just([:])
        } else {
            var possessionDic = [Int: Int]()
            list.forEach { possessionDic[$0.itemId] = $0.possessionNumber }
            return Observable.just(possessionDic)
        }
    }
    var currentCoins: Observable<Int> {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "ユーザーステータスを取得できませんでした") }
        self.status = status
        return Observable.just(status.numberOfCoins)
    }
    
    private var status: UserStatus!
    
    func savePossessionItemList(list: [Int : Int]) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        list.forEach { itemPossession in
            if let item  = realm.object(ofType: ItemPossession.self, forPrimaryKey: itemPossession.key) {
                try! realm.write {
                    item.possessionNumber += itemPossession.value
                }
            } else {
                try! realm.write {
                    realm.add(ItemPossession(id: itemPossession.key, possessionNumber: itemPossession.value))
                }
            }
        }
    }
    
    func saveFutureCoins(_ coins: Int) {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        try! realm.write {
            status.numberOfCoins = coins
        }
    }
}

// 正規実装後に削除
extension ItemShopModelImpl {
    private func getItems() -> [Item] {
        return [
            Item(id: 1, name: "普通の傷薬", price: 100, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPが少し回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 2, name: "水の護符", price: 200, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで水属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.water]),
            Item(id: 3, name: "ちょっと良い傷薬", price: 300, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPがまぁまぁ回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 4, name: "火の護符", price: 400, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで火属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.fire]),
            Item(id: 5, name: "良い傷薬", price: 500, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPがなかなか回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 6, name: "風の護符", price: 600, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで風属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.wind]),
            Item(id: 7, name: "かなり良い傷薬", price: 700, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPがかなり回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 8, name: "土の護符", price: 800, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで土属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.soil]),
            Item(id: 9, name: "めっちゃ良い傷薬", price: 900, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPがめっちゃ回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 10, name: "光の護符", price: 1000, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで光属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.light]),
            Item(id: 11, name: "最高の傷薬", price: 1100, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPが全回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 12, name: "闇の護符", price: 1200, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで闇属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.darkness])
        ]
    }
}
