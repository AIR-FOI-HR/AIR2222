import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SettingsViewController: UIViewController {
    
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var securityButton: UIButton!
    
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
