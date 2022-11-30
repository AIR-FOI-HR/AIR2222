//
//  ProfileController.swift
//  ProfilePicker
//
//  Created by Anas Zaheer on 11/12/17.
//  Copyright © 2017 nfnlabs. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController{
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textViewBio: UITextView!
    
    private let profileService = ProfileService()
    
    func getUser(){
        profileService.getUser { result in
            switch result {
            case .success(let user):
                for item in user {
                    self.nameTextfield.text = item.name
                    self.surnameTextField.text = item.surname
                    self.emailTextField.text = item.email
                    self.textViewBio.text = item.bio
                }
                return
            case .failure:
                return
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let userProfileData = getProfileData() else {
            alert(fwdMessage: "Please enter all required info.")
            return
        }
        
        updateUser(with: userProfileData)
    }
    
    func updateUser(with userUpdateData: UserProfileUpdateData) {
        profileService.updateUser(with: userUpdateData) { (isSuccess) in
            if isSuccess{
                self.alert(fwdMessage: "Successfully updated!")
                
            }else{
                self.alert(fwdMessage: "Please enter all required info.")
            }
        }
    }
    
    func getProfileData() -> UserProfileUpdateData? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = dateFormatter.string(from: datePicker.date)
                
        guard
            let name = nameTextfield.text,
            let surname = surnameTextField.text,
            let email = emailTextField.text,
            let bio  = textViewBio.text,

                !name.isEmpty && !surname.isEmpty && !email.isEmpty  && !bio.isEmpty
        else {
            return nil
        }
        
        let profileData = UserProfileUpdateData(name: name, surname: surname, email: email, gender: "", contact_no: "", birth_data: selectedDate, profile_pic: "", bio: bio)
        return profileData
    }
    
    func alert(fwdMessage: String){
        let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        getUser()
        let yesterdayDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = yesterdayDate
    }
}


