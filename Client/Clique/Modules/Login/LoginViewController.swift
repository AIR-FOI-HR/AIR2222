//
//  LoginViewContoller.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    private let loginService = LoginService()
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard
            let email = txtEmail.text,
            let password = txtPassword.text,
            !email.isEmpty && !password.isEmpty
        else {
            print("All fields must be filled.")
            return
        }
        
        let credentials = LoginCredentials(email: email,password: password)
        loginService.login(with: credentials) { result in
            switch result{
            case .success(let token):
                self.showAlert(with: "Token: \(token.token)")
                UserStorage.email = email
                
            case .failure:
                self.showPopUp()
                self.clearFields()
                
            }
                
            
        
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    
    func showAlert(with message: String){
        let alertController = UIAlertController()
        alertController.message = message
        
        present(alertController,animated:true)
    }
    
    @IBAction func showPopUp(){
        let alert = UIAlertController(title: "Wrong credentials", message: "Incorrect email or password.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){
            (action) in
            print(action)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    func clearFields(){
        txtPassword.text = ""
        
    }
}



