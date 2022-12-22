import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SecurityViewController: UIViewController {
    
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var oldPasswordTextField: UITextField!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var repeatNewPasswordTextField: UITextField!
    @IBOutlet private var passwordCheckLabel: UILabel!
    @IBOutlet private var matchingPasswordsLabel: UILabel!
    @IBOutlet private var savePasswordButton: UIButton!
    
    var iconClick = false
    let oldPasswordShowButton = UIButton(type: .custom)
    let newPasswordShowButton = UIButton(type: .custom)
    let repeatNewPasswordShowButton = UIButton(type: .custom)
    
    private let settingsService = SettingsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oldPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        repeatNewPasswordTextField.isSecureTextEntry = true

        self.showButton()
        
        newPasswordTextField.addTarget(self, action: #selector(checkAndDisplayError(textfield:)),
                                       for: .editingChanged)
        repeatNewPasswordTextField.addTarget(self, action:#selector(compareAndDisplay(textfield:)),
                                             for: .editingChanged)
    }
    
    func getPasswordData() -> PasswordData? {
        guard
            let oldPassword = oldPasswordTextField.text,
            let newPassword = newPasswordTextField.text,
            !oldPassword.isEmpty && !newPassword.isEmpty
        else { return nil }
        
        let newPasswordData = PasswordData(oldPassword: oldPassword, newPassword: newPassword)
        return newPasswordData
    }
        
    func updatePasswordUser(with userPasswords: PasswordData) {
        let defaultAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: {_ -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        settingsService.changePassword(with: userPasswords) { [weak self] result in
            switch result {
            case .success():
                self?.showAlert(message: Constants.Alerts.successfullyUpdatedMessage, actions: [defaultAction])
            case .failure:
                self?.showOKAlert(message: Constants.Alerts.pleaseEnterInfoMessage)
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let getPasswordData = getPasswordData() else {
            self.showOKAlert(message: Constants.Alerts.pleaseEnterInfoMessage)
            return
        }
        
        updatePasswordUser(with: getPasswordData)
    }
    
    func checkPasswords() -> Bool {
        if newPasswordTextField.text?.count ?? 0>=8 &&
            newPasswordTextField.text == repeatNewPasswordTextField.text {
            return true
        } else {
            return false
        }
    }

    @objc func checkAndDisplayError(textfield: UITextField) {
        if textfield.text?.count ?? 0>=8 {
            passwordCheckLabel.text = ""
            passwordCheckLabel.isHidden = true
        } else {
            passwordCheckLabel.isHidden = false
            passwordCheckLabel.text = "Enter at least 8 characters."
        }
    }

    @objc func compareAndDisplay(textfield: UITextField) {
        if textfield.text == newPasswordTextField.text {
            matchingPasswordsLabel.isHidden = true
        } else {
            matchingPasswordsLabel.text = "Passwords don't match."
            matchingPasswordsLabel.isHidden = false
        }
    }
    
    private func showButton() {
        oldPasswordShowButton.tintColor = UIColor.orange
        oldPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        oldPasswordShowButton.addTarget(self, action: #selector(self.refreshShowOldPassword), for: .touchUpInside)
        oldPasswordTextField.rightView = oldPasswordShowButton
        oldPasswordTextField.rightViewMode = .always
        oldPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordTextField.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        newPasswordShowButton.tintColor = UIColor.orange
        newPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        newPasswordShowButton.addTarget(self, action: #selector(self.refreshShowNewPassword), for: .touchUpInside)
        newPasswordTextField.rightView = newPasswordShowButton
        newPasswordTextField.rightViewMode = .always
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        repeatNewPasswordShowButton.tintColor = UIColor.orange
        repeatNewPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        repeatNewPasswordShowButton.addTarget(self, action: #selector(self.refreshShowRepeatNewPassword), for: .touchUpInside)
        repeatNewPasswordTextField.rightView = repeatNewPasswordShowButton
        repeatNewPasswordTextField.rightViewMode = .always
        repeatNewPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        repeatNewPasswordTextField.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @IBAction func refreshShowOldPassword(_ sender: Any) {
        if iconClick {
            oldPasswordTextField.isSecureTextEntry = true
            oldPasswordShowButton.tintColor = UIColor.orange
            oldPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            oldPasswordTextField.isSecureTextEntry = false
            oldPasswordShowButton.tintColor = UIColor.orange
            oldPasswordShowButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    @IBAction func refreshShowNewPassword(_ sender: Any) {
        if iconClick {
            newPasswordTextField.isSecureTextEntry = true
            newPasswordShowButton.tintColor = UIColor.orange
            newPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            newPasswordTextField.isSecureTextEntry = false
            newPasswordShowButton.tintColor = UIColor.orange
            newPasswordShowButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    @IBAction func refreshShowRepeatNewPassword(_ sender: Any) {
        if iconClick {
            repeatNewPasswordTextField.isSecureTextEntry = true
            repeatNewPasswordShowButton.tintColor = UIColor.orange
            repeatNewPasswordShowButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        } else {
            repeatNewPasswordTextField.isSecureTextEntry = false
            repeatNewPasswordShowButton.tintColor = UIColor.orange
            repeatNewPasswordShowButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
}
