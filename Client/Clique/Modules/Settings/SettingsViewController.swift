import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SettingsViewController: UIViewController {
    
<<<<<<< HEAD
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var securityButton: UIButton!
=======
    @IBOutlet private weak var logOutButton: UIButton!
    @IBOutlet private weak var securityButton: UIButton!
>>>>>>> bcdbc1ee1aaf6175e3c5263a58de16a9da83d5f4
    
    private var userStorage = UserStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        UserStorage.token = nil
        let storyboard = UIStoryboard(name: "Initial" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    @IBAction func securityButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "Security", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
