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
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    private let loginService = LoginService()
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard
            let email = emailTextField.text,
            let password = txtPassword.text,
            !email.isEmpty && !password.isEmpty
        else {
            return
        }
        
        let credentials = LoginCredentials(email: email, password: password)
        loginService.login(with: credentials) { result in
            switch result {
            case .success(let token):
                UserStorage.token = token.token
                UserStorage.email = email
            case .failure:
                let alert = UIAlertController(title: "Wrong Credentials",
                                              message: "Please enter your login info.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



