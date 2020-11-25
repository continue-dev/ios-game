import RxSwift

final class ItemShopViewModel {
    private let itemShopModel: ItemShopModelProtocol
    private let disposeBag = DisposeBag()
    
    private let itemListSubject = BehaviorSubject<[SectionObItemList]>(value: [])
    var itemList: Observable<[SectionObItemList]> {
        return itemListSubject.asObservable()
    }
    
    private let costCoinsSubject = BehaviorSubject<Int>(value: 0)
    var costCoins: Observable<Int> {
        return costCoinsSubject.asObservable()
    }
    
    private let editedPurchaseNumSubject = PublishSubject<Int>()
    var purchaseNumber: Observable<Int> {
        return editedPurchaseNumSubject.asObservable()
    }
    
    private let completePurchaseSubject = PublishSubject<Void>()
    var completePurchase: Observable<Void> {
        return completePurchaseSubject.asObservable()
    }
    
    private var purchaseList = [Int: Int]()
    private var haveCoins = 0
    
    lazy var currentCoins = itemShopModel.currentCoins.do(onNext:{ [weak self] value in self?.haveCoins = value })

    init(tabSelected: Observable<ItemCategoryTab.TabKind>, selectCell: Observable<ItemListModel>, hidePurchaseControl: Observable<Void>, purchasePlusTapped: Observable<Void>, purchaseMinusTapped: Observable<Void>, purchaseButtonTapped: Observable<Void>, itemShopModel: ItemShopModelProtocol = ItemShopModelImpl()) {
        self.itemShopModel = itemShopModel
        
        let oldItemList = BehaviorSubject<[ItemListModel]>(value: [])
        let selectedItemSubject = BehaviorSubject<ItemListModel?>(value: nil)
        selectCell.bind(to: selectedItemSubject).disposed(by: disposeBag)
        let selectedItem = selectedItemSubject.asObserver().filter { $0 != nil}.map{ $0!}
        
        
        let initialItemList = Observable<[ItemListModel]>
            .combineLatest(itemShopModel.itemList,
                           itemShopModel.possessionItemList) { [unowned self] items, possessions in
                            let itemList = items.map { ItemListModel(item: $0, possessionNumber: possessions[$0.id] ?? 0, purchaseNumber: self.purchaseList[$0.id] ?? 0)}
                            return itemList
        }
        
        let incrementItem = purchasePlusTapped
            .withLatestFrom(selectedItem) { ($0, $1) }
            .filter { [unowned self] (_, item) in return self.canPurchasingCost(addCost: item.item.price) }
            .map { [weak self] (_, item) -> ItemListModel in
                var editedItem = item
                var purchaseNum = 1
                if let alredyPurchaseNum = self?.purchaseList[editedItem.item.id] {
                    purchaseNum += alredyPurchaseNum
                }
                self?.purchaseList[editedItem.item.id] = purchaseNum
                editedItem.purchaseNumber = purchaseNum
                self?.editedPurchaseNumSubject.onNext(purchaseNum)
                return editedItem
        }.share()
        
        let decrementItem = purchaseMinusTapped
            .withLatestFrom(selectedItem) { ($0, $1) }
            .filter { $1.purchaseNumber > 0 }
            .map { [weak self] (_, item) -> ItemListModel in
                var editedItem = item
                guard let alredyPurchaseNum = self?.purchaseList[editedItem.item.id] else { return editedItem }
                let purchaseNum = alredyPurchaseNum - 1
                self?.purchaseList[editedItem.item.id] = purchaseNum
                editedItem.purchaseNumber = purchaseNum
                self?.editedPurchaseNumSubject.onNext(purchaseNum)
                return editedItem
        }.share()
        
        let newItemList = Observable.merge(selectCell, incrementItem, decrementItem)
            .withLatestFrom(oldItemList) { ($0, $1) }
            .map { (item, list) -> [ItemListModel] in
                var newList = list
                var selectItem = item
                selectItem.isSelected = true
                // 過去に選択されていたセルの選択状態を解除
                if var deSelectItem = list.first(where: { $0.isSelected }),
                    let index = list.firstIndex(where: { $0.item.id == deSelectItem.item.id}) {
                    deSelectItem.isSelected = false
                    newList[index] = deSelectItem
                }
                
                if let index = list.firstIndex(where: { $0.item.id == item.item.id }) {
                    newList[index] = selectItem
                }
                
                selectedItemSubject.onNext(selectItem)
                return newList
        }.share()
        
        newItemList.map { list in
            list.reduce(0) { $0 + $1.purchaseNumber * $1.item.price }
            }.bind(to: costCoinsSubject).disposed(by: disposeBag)
        
        let noSelectionList = hidePurchaseControl.withLatestFrom(oldItemList) { $1 }.map { list -> [ItemListModel] in
            var newList = list

            if var deSelectItem = list.first(where: { $0.isSelected }),
               let index = list.firstIndex(where: { $0.item.id == deSelectItem.item.id}) {
                deSelectItem.isSelected = false
                newList[index] = deSelectItem
            }
            return newList
        }
        
        let itemListStream = Observable.merge(initialItemList, newItemList, noSelectionList)
        itemListStream.bind(to: oldItemList).disposed(by: disposeBag)
        
        let filteredItemListStream = Observable.combineLatest(tabSelected, itemListStream) { ($0, $1) }
            .map { [unowned self] type, list in
                list.filter { self.convertItemType(tab: type).contains($0.item.itemType) }
        }
        
        filteredItemListStream.map { [SectionObItemList(items: $0)] }.bind(to: itemListSubject).disposed(by: disposeBag)
        
        purchaseButtonTapped.subscribe(onNext: { [weak self] _ in
            guard let list = self?.purchaseList else { return }
            guard let cost = try? self?.costCoinsSubject.value(), let current = self?.haveCoins else { return }
            self?.itemShopModel.savePossessionItemList(list: list.filter { $0.value > 0 })
            self?.itemShopModel.saveFutureCoins(current - cost)
            self?.completePurchaseSubject.onNext(())
        }).disposed(by: disposeBag)
    }
    
    private func convertItemType(tab: ItemCategoryTab.TabKind) -> [Item.ItemType] {
        switch tab {
        case .all:
            return [.amulet, .medicine, .equipment]
        case .amulet:
            return [.amulet]
        case .medicine:
            return [.medicine]
        case .equipment:
            return [.equipment]
        }
    }
    
    private func canPurchasingCost(addCost: Int) -> Bool {
        guard let base = try? costCoinsSubject.value() else { return false }
        return haveCoins >= base + addCost
    }
}
