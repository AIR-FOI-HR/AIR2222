
//
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import UIKit

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
    private var selectedGender = ""
    private let registerService = RegisterService()
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {

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
            emptyFieldsLabel.text = "All fields must be filled."
            emptyFieldsLabel.isHidden = false
            return
        }

        let entries = RegisterEntries(email: email,password: password, name: name, surname: surname, contactNum: contactNum, gender: genderCheck(), birthData: birthData )

            if(checkPasswords() == true){

                registerService.register(with: entries){
                    (isSuccess) in
                    if isSuccess{
                        let alertController = UIAlertController(title: "", message: "Successfully registrated!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        return
                    }
                }
            }
            else{
                return
            }
    }

        override func viewDidLoad() {
            super.viewDidLoad()

            genderPickerView.delegate = self
            genderPickerView.dataSource = self
            
            passwordCheckLabel.isHidden = true
            matchingPasswordsLabel.isHidden = true
            emptyFieldsLabel.isHidden = true

            txtPassword.isSecureTextEntry = true
            txtRePassword.isSecureTextEntry = true

            pickerView.delegate = self
            pickerView.dataSource = self

            dPdateOfBirth.maximumDate = Date()

            txtPassword.addTarget(self, action: #selector(checkAndDisplayError(textfield:)), for: .editingChanged)
            txtRePassword.addTarget(self, action: #selector(compareAndDisplay(textfield:)), for: .editingChanged)

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

    private func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) -> String {
        selectedGender = genders[row] as String
        return selectedGender
    }


}



