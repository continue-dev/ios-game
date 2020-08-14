import UIKit

struct Item {
    let id: Int
    let name: String
    let price: Int
    let icon: UIImage
    let image: UIImage
    let info: String
    let itemType: ItemType
    let attributeTypes: [AttributeType]
    
    enum ItemType {
        case medicine
        case amulet
        case equipment
    }
}
