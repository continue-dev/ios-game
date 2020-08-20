import Foundation
import RxSwift
import RealmSwift

protocol ItemShopModelProtocol {
    var itemList: Observable<[Item]> { get }
    var possessionItemList: Observable<[Int: Int]> { get }
    var currentCoins: Observable<Int> { get }
}

final class ItemShopModelImpl: ItemShopModelProtocol {
    var itemList: Observable<[Item]> {
        return Observable.just(getItems())
    }
    var possessionItemList: Observable<[Int : Int]> {
        return Observable.just([1: 1])
    }
    var currentCoins: Observable<Int> {
        guard let realm = try? Realm() else { assert(false, "Realmをインスタンス化できませんでした") }
        guard let status = realm.objects(UserStatus.self).first else { assert(false, "ユーザーステータスを取得できませんでした") }
        return Observable.just(status.numberOfCoins)
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
