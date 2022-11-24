//
//  Clique
//  Created by Infinum on 15.11.2022..
//

import UIKit
import NVActivityIndicatorView

class RegisterViewController: UIViewController {

    @IBOutlet private weak var txtName: UITextField!
    @IBOutlet private weak var txtSurname: UITextField!
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var txtRePassword: UITextField!
    @IBOutlet private weak var txtPhoneNumber: UITextField!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var dPdateOfBirth: UIDatePicker!
    @IBOutlet private weak var passwordCheckLabel: UILabel!
    @IBOutlet private weak var matchingPasswordsLabel: UILabel!
    @IBOutlet private weak var emptyFieldsLabel: UILabel!
    @IBOutlet private weak var genderPickerView: UIPickerView!
    

    let genders = ["Male", "Female", "Non-binary"]
    var pickerView = UIPickerView()
    private var selectedGender : String?
    private let registerService = RegisterService()
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        guard let registerEntries = getRegisterEntries() else {
            emptyFieldsLabel.text = "All fields must be filled."
            emptyFieldsLabel.isHidden = false
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
//            self.hideKeyboardWhenTappedAround()
            
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
            pickerView.delegate = self
            pickerView.dataSource = self
            passwordCheckLabel.isHidden = true
            matchingPasswordsLabel.isHidden = true
            emptyFieldsLabel.isHidden = true
            txtPassword.isSecureTextEntry = true
            txtRePassword.isSecureTextEntry = true
            dPdateOfBirth.maximumDate = Date()
            
//            self.txtName.delegate = self
//            self.txtSurname.delegate = self
//            txtEmail.delegate = self
//            txtPhoneNumber.delegate = self
//            txtPassword.delegate = self
//            txtRePassword.delegate = self
        

            txtPassword.addTarget(self, action: #selector(checkAndDisplayError(textfield:)), for: .editingChanged)
            txtRePassword.addTarget(self, action: #selector(compareAndDisplay(textfield:)), for: .editingChanged)

        }
    
        func getRegisterEntries() -> RegisterEntries? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let birthData = dateFormatter.string(from: dPdateOfBirth.date)
        
            guard
                let name = txtName.text,
                let surname = txtSurname.text,
                let email = txtEmail.text,
                let password = txtPassword.text,
                let rePassword = txtRePassword.text,
                let contactNum = txtPhoneNumber.text,

            !name.isEmpty && !surname.isEmpty && !email.isEmpty && !password.isEmpty && !rePassword.isEmpty && !contactNum.isEmpty
                    
            else {
                return nil
            }
            let entries = RegisterEntries(email: email,password: password, name: name, surname: surname, contactNum: contactNum, gender: genderCheck(), birthData: birthData )
            return entries

        }

        func genderCheck() -> Int{
            var chosenGender = 0

            if(selectedGender == "Male"){
                chosenGender = 1
            }
            else if(selectedGender == "Female"){
                chosenGender = 2
            }
            else if(selectedGender == "Non-binary"){
                chosenGender = 3
            }
            return chosenGender
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

extension RegisterViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedGender = genders[row]
        return genders[row]
    }

    private func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) -> String? {
        selectedGender = genders[row] as String
        return selectedGender
    }
    
    
}

//extension RegisterViewController : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == txtName {
//            txtSurname.becomeFirstResponder()
//        }
//        if textField == txtSurname{
//            txtPhoneNumber.becomeFirstResponder()
//        }
//        if textField == txtPhoneNumber{
//            txtEmail.becomeFirstResponder()
//        }
//        if textField == txtEmail{
//            txtPassword.becomeFirstResponder()
//        }
//        if textField == txtPassword{
//            txtRePassword.becomeFirstResponder()
//        }
//        return true
//    }
//
//}



