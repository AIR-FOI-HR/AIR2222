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
    
    @IBOutlet private var imageProfile: UIImageView!
    @IBOutlet private var buttonChooseImage: UIButton!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var nameTextfield: UITextField!
    @IBOutlet private var surnameTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var bioTextView: UITextView!
    
    private let profileService = ProfileService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        let allowedAgeDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        datePicker.maximumDate = allowedAgeDate
        imageProfile.layer.masksToBounds = false
        imageProfile.isSkeletonable = true
        imageProfile.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        emailTextField.layer.masksToBounds = false
        emailTextField.isSkeletonable = true
        emailTextField.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        nameTextfield.layer.masksToBounds = false
        nameTextfield.isSkeletonable = true
        nameTextfield.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        surnameTextField.layer.masksToBounds = false
        surnameTextField.isSkeletonable = true
        surnameTextField.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        bioTextView.layer.masksToBounds = false
        bioTextView.isSkeletonable = true
        bioTextView.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        datePicker.layer.masksToBounds = false
        datePicker.isSkeletonable = true
        datePicker.showAnimatedSkeleton(usingColor: .clouds, transition: .crossDissolve(0.5))
        
        SkeletonAppearance.default.skeletonCornerRadius = 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUser()
    }
    
    private func getUser() {
        profileService.getUser { result in
            switch result {
            case .success(let user):
                    self.nameTextfield.text = user.name
                    self.surnameTextField.text = user.surname
                    self.emailTextField.text = user.email
                    self.bioTextView.text = user.bio
                    self.imageProfile.stopSkeletonAnimation()
                    self.emailTextField.stopSkeletonAnimation()
                    self.nameTextfield.stopSkeletonAnimation()
                    self.surnameTextField.stopSkeletonAnimation()
                    self.bioTextView.stopSkeletonAnimation()
                    self.datePicker.stopSkeletonAnimation()
                    
                    self.view.hideSkeleton(reloadDataAfter: true,
                                           transition: .crossDissolve(0.5))
            case .failure:
                return
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let userProfileData = getProfileData() else {
            Functions.Alerts.alert(fwdMessage: Constants.Alerts.pleaseEnterInfoMsg, viewController: self)
            return
        }
        
        updateUser(with: userProfileData)
        dismiss(animated: true, completion: nil)
    }
    
    func updateUser(with userUpdateData: UserProfileUpdateData) {
        profileService.updateUser(with: userUpdateData) { (isSuccess) in
            let message = isSuccess ? Constants.Alerts.successfullyUpdatedMsg : Constants.Alerts.pleaseEnterInfoMsg
            Functions.Alerts.alert(fwdMessage: message, viewController: self)
        }
    }
    
    func getProfileData() -> UserProfileUpdateData? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Strings.dateFormat
        let selectedDate = dateFormatter.string(from: datePicker.date)
                
        guard
            let name = nameTextfield.text,
            let surname = surnameTextField.text,
            let email = emailTextField.text,
            let bio  = bioTextView.text,
            !name.isEmpty, !surname.isEmpty, !email.isEmpty, !bio.isEmpty
        else { return nil }
        
        let profileData = UserProfileUpdateData(
                        name: name,
                        surname: surname,
                        email: email,
                        contact_no: "empty",
                        birth_data: selectedDate,
                        profile_pic: "empty",
                        bio: bio
               )
        return profileData
    }
    
    @IBAction func closeProfileEditViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
