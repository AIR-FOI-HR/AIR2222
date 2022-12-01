import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SecurityViewController: UIViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBAction func closeSettingsViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

