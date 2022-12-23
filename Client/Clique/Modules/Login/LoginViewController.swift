//
//  LoginViewContoller.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var loginButton: UIButton!
    
    private let loginService = LoginService()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
    var iconClick = false
    let buttonPasswordShow = UIButton(type: .custom)
    
    override func viewDidLoad() {
        self.showButton()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        self.startAnimation(loading: loading, view: view)
        guard let credentails = getLoginCredentials() else {
            self.showAlert(message: Constants.Alerts.pleaseEnterInfoMessage, actionTitle: Constants.Alerts.defaultOKActionTitle)
            self.startAnimation(loading: loading, view: view)
            return
        }
        login(with: credentails)
}
    
    func getLoginCredentials() -> LoginCredentials? {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty && !password.isEmpty
        else { return nil }
        let credentials = LoginCredentials(email: email, password: password)
        return credentials
    }
    
    func login(with credentials: LoginCredentials) {
        loginService.login(with: credentials) { result in
            switch result {
            case .success(let token):
                UserStorage.token = token.token
                let storyboard = UIStoryboard(name: "TabBar" , bundle: nil)
                guard let viewController = storyboard.instantiateInitialViewController()
                else { return }
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
                self.stopAnimation(loading: self.loading)
            case .failure:
                self.showAlert(message: Constants.Alerts.wrongCredentialsMessage)
                self.stopAnimation(loading: self.loading)
            }
        }
    }
    
    private func showButton() {
        buttonPasswordShow.tintColor = UIColor.orange
        buttonPasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        buttonPasswordShow.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        passwordTextField.rightView = buttonPasswordShow
        passwordTextField.rightViewMode = .always
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    @IBAction func closeLoginViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
