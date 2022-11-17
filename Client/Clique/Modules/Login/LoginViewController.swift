//
//  LoginViewController.swift
//  Clique
//
//  Created by Infinum on 17.11.2022..
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard
            let email = txtEmail.text,
            let password = txtPassword.text,
            !email.isEmpty && !password.isEmpty
        else {
            print("All fields must be filled.")
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
