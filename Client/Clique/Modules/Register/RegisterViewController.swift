//
//  Clique
//  Created by Infinum on 15.11.2022..
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class RegisterViewController: UIViewController {

    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var txtSurname: UITextField!
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var txtRePassword: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var passwordCheckLabel: UILabel!
    @IBOutlet private weak var matchingPasswordsLabel: UILabel!
    @IBOutlet private weak var ageSwitcher: UISwitch!
    @IBOutlet private weak var backButton: UIButton!
    
    var iconClick = false
    let buttonPasswordShow = UIButton(type: .custom)
    let buttonRePasswordShow = UIButton(type: .custom)
    
    private let registerService = RegisterService()
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        guard let registerEntries = getRegisterEntries() else {
            alert(fwdMessage: "Please fill all required information.")
            return
        }
        
        guard checkPasswords() else{
            alert(fwdMessage: "Passwords don't match.")
            return
        }
        startAnimation()
        register(with: registerEntries)
    }
        func register(with registerEntries: RegisterEntries) {
            registerService.register(with: registerEntries) { (isSuccess) in
                    if isSuccess{
                        self.alert(fwdMessage: "Successfully registrated!")
                        self.stopAnimation()
                    }else{
                        self.alert(fwdMessage: "Wrong input.")
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
            
            passwordCheckLabel.isHidden = true
            matchingPasswordsLabel.isHidden = true
            txtPassword.isSecureTextEntry = true
            txtRePassword.isSecureTextEntry = true
            registerButton.isEnabled = false
            
            self.showButton()
        
            returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
            
            txtPassword.addTarget(self, action: #selector(checkAndDisplayError(textfield:)), for: .editingChanged)
            txtRePassword.addTarget(self, action: #selector(compareAndDisplay(textfield:)), for: .editingChanged)
            ageSwitcher.addTarget(self, action:
                #selector(registerButtonEnabled(switcher:)), for: .valueChanged)

        }
    
        func getRegisterEntries() -> RegisterEntries? {
        
            guard
                let name = txtName.text,
                let surname = txtSurname.text,
                let email = txtEmail.text,
                let password = txtPassword.text,
                let rePassword = txtRePassword.text,

            !name.isEmpty && !surname.isEmpty && !email.isEmpty && !password.isEmpty && !rePassword.isEmpty
                    
            else {
                return nil
            }
            let entries = RegisterEntries(email: email,password: password, name: name, surname: surname)
            return entries

        }

        func checkPasswords() -> Bool {
            var check = false

            if(txtPassword.text?.count ?? 0>=8 && txtPassword.text == txtRePassword.text){
                    check = true
            }else{
                check = false
            }
            return check
        }

        @objc func checkAndDisplayError (textfield: UITextField) {

            if (textfield.text?.count ?? 0>=8){
                passwordCheckLabel.text = ""
                passwordCheckLabel.isHidden = true
            }
            else{
                passwordCheckLabel.isHidden = false
                passwordCheckLabel.text = "Enter at least 8 characters."
            }
        }

        @objc func compareAndDisplay (textfield: UITextField) {

            if (textfield.text == txtPassword.text ){
                matchingPasswordsLabel.isHidden = true
            }
            else{
                matchingPasswordsLabel.text = "Passwords don't match."
                matchingPasswordsLabel.isHidden = false
            }
        }
    
        @objc func registerButtonEnabled (switcher: UISwitch) {
            if(switcher.isOn){
                registerButton.isEnabled = true
            }else if(!switcher.isOn){
                registerButton.isEnabled = false
            }
        
        }
    
    private func showButton() {
        buttonPasswordShow.tintColor = UIColor.orange
        buttonRePasswordShow.tintColor = UIColor.orange
        buttonPasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        buttonRePasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        buttonPasswordShow.addTarget(self, action: #selector(self.refreshShowPassword), for: .touchUpInside)
        buttonRePasswordShow.addTarget(self, action: #selector(self.refreshShowRePassword), for: .touchUpInside)
        txtPassword.rightView = buttonPasswordShow
        txtPassword.rightViewMode = .always
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        txtRePassword.rightView = buttonRePasswordShow
        txtRePassword.rightViewMode = .always
        txtRePassword.translatesAutoresizingMaskIntoConstraints = false
        txtRePassword.rightView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @IBAction func refreshShowPassword(_ sender: Any) {
        if iconClick {
            txtPassword.isSecureTextEntry = true
            buttonPasswordShow.tintColor = UIColor.orange
            buttonPasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        else {
            txtPassword.isSecureTextEntry = false
            buttonPasswordShow.tintColor = UIColor.orange
            buttonPasswordShow.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    @IBAction func refreshShowRePassword(_ sender: Any) {
        if iconClick {
            txtRePassword.isSecureTextEntry = true
            buttonRePasswordShow.tintColor = UIColor.orange
            buttonRePasswordShow.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        else {
            txtRePassword.isSecureTextEntry = false
            buttonRePasswordShow.tintColor = UIColor.orange
            buttonRePasswordShow.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
    private func startAnimation() {
            loading.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loading)
            NSLayoutConstraint.activate([
                loading.widthAnchor.constraint(equalToConstant: 40),
                loading.heightAnchor.constraint(equalToConstant: 40),
                loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 350),
                loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            loading.startAnimating()
        }
    private func stopAnimation() {
            loading.stopAnimating()
        }
    
    @IBAction func closeRegisterViewController(_ sender: UIButton){
            dismiss(animated: true, completion: nil)
    }
    
}


