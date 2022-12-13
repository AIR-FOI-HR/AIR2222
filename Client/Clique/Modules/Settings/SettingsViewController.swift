import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SettingsViewController: UIViewController {
    
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var securityButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        let okAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: {_ -> Void in
            let storyboard = UIStoryboard(name: "Initial" , bundle:nil)
            guard let viewController = storyboard.instantiateInitialViewController()
            else { return }
            UserStorage.token = nil
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        })
        let cancelAction = UIAlertAction(title: Constants.Alerts.defaultCancelActionTitle, style: .destructive)

        sendOKCancelAlert(message: Constants.Alerts.wantToLogOutMessage, actions: [okAction,cancelAction])
    }
    
    @IBAction func securityButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "Security", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
