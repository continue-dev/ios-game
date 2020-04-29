import UIKit
import RxSwift

class CreateEnemyViewController: UIViewController {
    
    @IBOutlet private weak var hpField: UITextField!
    @IBOutlet private weak var attackField: UITextField!
    @IBOutlet private weak var attackTypeView: AttributeSelectView!
    @IBOutlet private weak var defenseField: UITextField!
    @IBOutlet private weak var defenseTypeView: AttributeSelectView!
    @IBOutlet private weak var fireProportionField: UITextField!
    @IBOutlet private weak var waterProportionField: UITextField!
    @IBOutlet private weak var windProportionField: UITextField!
    @IBOutlet private weak var enemyProportionField: UITextField!
    @IBOutlet private weak var soilProportionField: UITextField!
    @IBOutlet private weak var lightProportionField: UITextField!
    @IBOutlet private weak var darknessProportionField: UITextField!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var enterButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let enemyImageNames = ["enemy_sample_small", "enemy_sample_big"]
    
    private var attackTypes = [AttributeType]()
    private var defenseTypes = [AttributeType]()
    private var selectedImageName: String?
    
    var editingEnemy: (index: Int, enemy:Enemy)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchEditingEnemy()
    }
    
    private func setUp() {
        hpField.becomeFirstResponder()
        collectionView.register(EnemyImageCollectionCell.self, forCellWithReuseIdentifier: "cell")
        
        attackTypeView.selectAttributesObserver.subscribe(onNext:{ [weak self] attrs in
            self?.attackTypes = attrs
        }).disposed(by: disposeBag)
        defenseTypeView.selectAttributesObserver.subscribe(onNext:{ [weak self] attrs in
            self?.defenseTypes = attrs
        }).disposed(by: disposeBag)
    }
    
    private func fetchEditingEnemy() {
        guard let enemy = self.editingEnemy?.enemy else { return }
        hpField.text = "\(enemy.hp)"
        attackField.text = "\(enemy.attack)"
        attackTypeView.setSelected(attributes: enemy.attackType)
        defenseField.text = "\(enemy.defense)"
        defenseTypeView.setSelected(attributes: enemy.defenseType)
        fireProportionField.text = "\(enemy.probability.fire)"
        waterProportionField.text = "\(enemy.probability.water)"
        windProportionField.text = "\(enemy.probability.wind)"
        soilProportionField.text = "\(enemy.probability.soil)"
        lightProportionField.text = "\(enemy.probability.light)"
        darknessProportionField.text = "\(enemy.probability.darkness)"
        enemyProportionField.text = "\(enemy.probability.enemy)"
        selectedImageName = enemy.imageName
        collectionView.reloadData()
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let enemy = Enemy(id: 0, name: "", hp: Int64(hpField.text!)!, attack: Int64(attackField.text!)!, defense: Int64(defenseField.text!)!, attackType: attackTypes.sorted(by: {$0.rawValue < $1.rawValue}), defenseType: defenseTypes.sorted(by: {$0.rawValue < $1.rawValue}), imageName: selectedImageName!, type: Enemy.EnemyType(rawValue: enemyImageNames.firstIndex(of: selectedImageName!)!)!, probability: Probability(fire: Int(fireProportionField.text!)!, water: Int(waterProportionField.text!)!, wind: Int(windProportionField.text!)!, soil: Int(soilProportionField.text!)!, light: Int(lightProportionField.text!)!, darkness: Int(darknessProportionField.text!)!, enemy: Int(enemyProportionField.text!)!))
        
        let parent = (self.presentingViewController as! NavigationViewController).currentViewController as! TuningStageViewController
        if let editing = self.editingEnemy {
            parent.enemies[editing.index] = enemy
        } else {
            parent.enemies.append(enemy)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func validateAllFields() {
        let inputs = [hpField, attackField, defenseField, fireProportionField, waterProportionField, windProportionField, soilProportionField, enemyProportionField, lightProportionField, darknessProportionField].map{$0?.text}
        enterButton.isEnabled = inputs.filter{$0?.isEmpty ?? true}.count == 0 && self.selectedImageName != nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        validateAllFields()
        self.view.endEditing(true)
    }
}

extension CreateEnemyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return enemyImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EnemyImageCollectionCell
        cell.imageView?.image = UIImage(named: self.enemyImageNames[indexPath.row])
        cell.contentView.alpha = selectedImageName == self.enemyImageNames[indexPath.row] ? 1 : 0.3
        return cell
    }
}

extension CreateEnemyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height * 0.6, height: height)
    }
}

extension CreateEnemyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImageName = self.enemyImageNames[indexPath.row]
        self.validateAllFields()
        self.view.endEditing(true)
        collectionView.reloadData()
    }
}
