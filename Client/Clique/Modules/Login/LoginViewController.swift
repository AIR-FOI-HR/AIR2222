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
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let loginService = LoginService()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
    var iconClick = false
    let buttonPasswordShow = UIButton(type: .custom)
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        Functions.Animations.startAnimation(loading: loading, view: view)
        guard let credentails = getLoginCredentials() else {
            Functions.Alerts.alert(message: Constants.Alerts.pleaseEnterInfoMessasge, viewController: self)
            Functions.Animations.stopAnimation(loading: self.loading)
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
                let storyboard = UIStoryboard(name: "BasicInfo", bundle: nil)
                if let viewContoller = storyboard.instantiateInitialViewController() {
                    viewContoller.modalPresentationStyle = .fullScreen
                    self.present(viewContoller, animated: true)
                }
                Functions.Animations.stopAnimation(loading: self.loading)
            case .failure:
                Functions.Alerts.alert(message: Constants.Alerts.pleaseEnterInfoMessasge, viewController: self)
                Functions.Animations.stopAnimation(loading: self.loading)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        self.showButton()
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
