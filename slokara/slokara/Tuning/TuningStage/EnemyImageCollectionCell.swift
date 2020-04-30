import UIKit

class EnemyImageCollectionCell: UICollectionViewCell {
    
    weak var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        let imageView = UIImageView()
        self.contentView.addSubview(imageView)
        imageView.frame = self.bounds
        self.imageView = imageView
    }
}
