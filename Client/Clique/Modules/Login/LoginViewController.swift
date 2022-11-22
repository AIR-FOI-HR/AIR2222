//
//  LoginViewContoller.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let loginService = LoginService()
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let credentails = getLoginCredentials() else {
            showAlert(title: "Insufficient information", message: "Please enter email and password")
            return
        }
        
        login(with: credentails)
}
    
    func getLoginCredentials() -> LoginCredentials? {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty && !password.isEmpty
        else {
            return nil
        }
        let credentials = LoginCredentials(email: email, password: password)
        return credentials
    }
    
    func login(with credentials: LoginCredentials) {
        loginService.login(with: credentials) { result in
            switch result {
            case .success(let token):
                UserStorage.token = token.token
                UserStorage.email = credentials.email
            case .failure:
                self.showAlert(title: "Wrong credentials", message: "Please enter your login info")
            }
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.showButton()
    }
    
    
    var iconClick = false
    let buttonPasswordShow = UIButton(type: .custom)
    
    private func showButton() {
        buttonPasswordShow.tintColor = UIColor.orange
        buttonPasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        buttonPasswordShow.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width + 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20))
        buttonPasswordShow.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        passwordTextField.rightView = buttonPasswordShow
        passwordTextField.rightViewMode = .always
    }
    
    @IBAction func refresh(_ sender: Any) {
        if iconClick {
            passwordTextField.isSecureTextEntry = true
            buttonPasswordShow.tintColor = UIColor.orange
            buttonPasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        else {
            passwordTextField.isSecureTextEntry = false
            buttonPasswordShow.tintColor = UIColor.orange
            buttonPasswordShow.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            
        }
        iconClick = !iconClick
    }
    
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
