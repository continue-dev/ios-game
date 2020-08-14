import Foundation
import RxSwift

protocol ItemShopModelProtocol {
    var itemList: Observable<[Item]> { get }
    var possessionItemList: Observable<[Int: Int]> { get }
}

final class ItemShopModelImpl: ItemShopModelProtocol {
    var itemList: Observable<[Item]> {
        return Observable.just(getItems())
    }
    var possessionItemList: Observable<[Int : Int]> {
        return Observable.just([1: 1])
    }
}

// 正規実装後に削除
extension ItemShopModelImpl {
    private func getItems() -> [Item] {
        return [
            Item(id: 1, name: "普通の傷薬", price: 100, icon: UIImage(named: "medicine_icon")!, image: UIImage(named: "medicine_color")!, info: "HPが少し回復する", itemType: .medicine, attributeTypes: []),
            Item(id: 2, name: "水の護符", price: 200, icon: UIImage(named: "amulet_icon")!, image: UIImage(named: "amulet_color")!, info: "使用ターンに限りリールで水属性の停止確率が上がる", itemType: .amulet, attributeTypes: [.water])
        ]
    }
}
