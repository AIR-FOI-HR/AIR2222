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
    @IBOutlet private weak var errorMessage: UILabel!
    
    private let loginService = LoginService()
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard
            let email = emailTextField.text,
            let password = txtPassword.text,
            !email.isEmpty && !password.isEmpty
        else {
            self.errorMessage.isHidden = false
            self.errorMessage.text = "All fields must be filled!"
            return
        }
        
        let credentials = LoginCredentials(email: email, password: password)
        loginService.login(with: credentials) { result in
            switch result {
            case .success(let token):
                UserStorage.token = token.token
                UserStorage.email = email
                self.errorMessage.isHidden = true
            case .failure:
                self.errorMessage.isHidden = false
                self.errorMessage.text = "Your credentials are invalid."
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.isHidden = true
    }
}



