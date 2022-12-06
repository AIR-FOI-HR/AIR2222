//
//  ProfileController.swift
//  ProfilePicker
//
//  Created by Anas Zaheer on 11/12/17.
//  Copyright © 2017 nfnlabs. All rights reserved.
//

import UIKit
import SkeletonView

class ProfileEditViewController: UIViewController {
    
    @IBOutlet private var imgProfile: UIImageView!
    @IBOutlet private var btnChooseImage: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var nameTextfield: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var textViewBio: UITextView!
    
    private let profileService = ProfileService()
    
    func getUser() {
        profileService.getUser { result in
            switch result {
            case .success(let user):
                for item in user {
                    self.nameTextfield.text = item.name
                    self.surnameTextField.text = item.surname
                    self.emailTextField.text = item.email
                    self.textViewBio.text = item.bio
                    self.imgProfile.stopSkeletonAnimation()
                    self.emailTextField.stopSkeletonAnimation()
                    self.nameTextfield.stopSkeletonAnimation()
                    self.surnameTextField.stopSkeletonAnimation()
                    self.textViewBio.stopSkeletonAnimation()
                    self.datePicker.stopSkeletonAnimation()
                    
                    self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                }
                return
            case .failure:
                return
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let userProfileData = getProfileData() else {
            alert(fwdMessage: "Please enter all required info.")
            return
        }
        updateUser(with: userProfileData)
        dismiss(animated: true, completion: nil)
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
        
        let profileData = UserProfileUpdateData(name: name, surname: surname, email: email, gender: "1", contact_no: "empty", birth_data: selectedDate, profile_pic: "empty", bio: bio)
        return profileData
    }
    
    func alert(fwdMessage: String) {
        let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func closeProfileEditViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        let allowedAgeDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = allowedAgeDate
        imgProfile.layer.masksToBounds = false
        imgProfile.isSkeletonable = true
        imgProfile.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        emailTextField.layer.masksToBounds = false
        emailTextField.isSkeletonable = true
        emailTextField.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        nameTextfield.layer.masksToBounds = false
        nameTextfield.isSkeletonable = true
        nameTextfield.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        surnameTextField.layer.masksToBounds = false
        surnameTextField.isSkeletonable = true
        surnameTextField.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        textViewBio.layer.masksToBounds = false
        textViewBio.isSkeletonable = true
        textViewBio.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        datePicker.layer.masksToBounds = false
        datePicker.isSkeletonable = true
        datePicker.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        SkeletonAppearance.default.skeletonCornerRadius = 100
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUser()
    }
}


