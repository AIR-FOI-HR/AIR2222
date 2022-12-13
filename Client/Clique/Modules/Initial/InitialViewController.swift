import UIKit

class InitialViewController: UIViewController {

    @IBOutlet private var logInButton: UIButton!
    @IBOutlet private var registerButton: UIButton!
    
    @IBAction func loginButtonPressed( sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login" , bundle:nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    @IBAction func registerButtonPressed( sender: UIButton) {
        let storyboard = UIStoryboard(name: "Register" , bundle:nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
