import UIKit

class TuningReelViewController: UIViewController, NavigationChildViewController {
    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet private weak var topLeftCharButton: ToggleButton!
    @IBOutlet private weak var topCenterCharButton: ToggleButton!
    @IBOutlet private weak var topRightCharButton: ToggleButton!
    @IBOutlet private weak var middleLeftCharButton: ToggleButton!
    @IBOutlet private weak var middleCenterCharButton: ToggleButton!
    @IBOutlet private weak var middleRightCharButton: ToggleButton!
    @IBOutlet private weak var bottomLeftCharButton: ToggleButton!
    @IBOutlet private weak var bottomCenterCharButton: ToggleButton!
    @IBOutlet private weak var bottomRightCharButton: ToggleButton!
    @IBOutlet weak var enterButton: UIButton!
    
    private var top: [ToggleButton] {
        return [topLeftCharButton, topCenterCharButton, topRightCharButton]
    }
    
    private var middle: [ToggleButton] {
        return [middleLeftCharButton, middleCenterCharButton, middleRightCharButton]
    }
    
    private var bottom: [ToggleButton] {
        return [bottomLeftCharButton, bottomCenterCharButton, bottomRightCharButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        guard let json =  UserDefaults.standard.data(forKey: "reel") else {
            top.forEach{ $0.isOn = false }
            middle.forEach{ $0.isOn = true }
            bottom.forEach{ $0.isOn = false }
            return
        }
        guard let reel = try? JSONDecoder().decode(Reel.self, from: json) else { fatalError("Reel decode failed.") }
        reel.top.enumerated().forEach{offset, element in top[offset].isOn = element }
        reel.center.enumerated().forEach{offset, element in middle[offset].isOn = element }
        reel.bottom.enumerated().forEach{offset, element in bottom[offset].isOn = element }
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let reel = Reel(top: top.map{ $0.isOn }, center: middle.map{ $0.isOn }, bottom: bottom.map{ $0.isOn })
        guard let json = try? JSONEncoder().encode(reel) else { fatalError("Reel encode failed.") }
        UserDefaults.standard.set(json, forKey: "reel")
        
        let navigation = self.parent as? NavigationViewController
        navigation?.popViewController(animate: true)
    }
    
    @IBAction func charButtonTapped(_ sender: Any) {
        let chars: [Bool] = (top + middle + bottom).map{ $0.isOn }
        self.enterButton.isEnabled = chars.contains(true)
    }
    
}
