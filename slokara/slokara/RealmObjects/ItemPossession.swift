import Foundation
import RealmSwift

class ItemPossession: Object {
    @objc dynamic var itemId: Int
    @objc dynamic var possessionNumber: Int
    
    override class func primaryKey() -> String? {
        return "itemId"
    }
    
    init(id: Int, possessionNumber: Int) {
        self.itemId = id
        self.possessionNumber = possessionNumber
    }
    
    required override init() {
        self.itemId = -1
        self.possessionNumber = 0
    }
}
