import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SettingsViewController: UIViewController {

    
    @IBOutlet private weak var logOutButton: UIButton!
    
    var userStorage = UserStorage()
    
    @IBAction func logOutButtonPressed(_ sender: UIButton){
        userStorage.removeKey(key: UserStorageValues.token)
        let storyboard = UIStoryboard(name: "Initial" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            self.present(viewController, animated: true)
        }
    }

}
