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
    var iconClick = false
    let buttonPasswordShow = UIButton(type: .custom)
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        startAnimation()
        guard let credentails = getLoginCredentials() else {
            alert(fwdMessage: "Please enter email and password")
            stopAnimation()
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
                let storyboard = UIStoryboard(name: "Settings" , bundle:nil)
                if let viewController = storyboard.instantiateInitialViewController() {
                    self.present(viewController, animated: true)
                    //                    self.show(viewController, sender: true)
                }
                self.stopAnimation()
            case .failure:
                self.alert(fwdMessage: "Please enter your login info")
                self.stopAnimation()
            }
        }
    }
    
    func alert(fwdMessage: String){
        let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
        func startAnimation() {
                loading.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(loading)
                NSLayoutConstraint.activate([
                    loading.widthAnchor.constraint(equalToConstant: 40),
                    loading.heightAnchor.constraint(equalToConstant: 40),
                    loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
                    loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                ])
                loading.startAnimating()
            }
        func stopAnimation() {
                loading.stopAnimating()
            }
    
    @IBAction func closeLoginViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
