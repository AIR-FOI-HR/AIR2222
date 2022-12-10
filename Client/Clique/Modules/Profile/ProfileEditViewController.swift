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
    @IBOutlet private var dateOfBirthLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var bioTextView: UITextView!
    
    private let profileService = ProfileService()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getUser()
//        let allowedAgeDate = Calendar.current.date(byAdding: .year, value: -13, to: Date())
//        datePicker.maximumDate = allowedAgeDate
//
//        imageProfile.rounded()
//
//        imageProfile.skeletonableView()
//        emailTextField.skeletonableView()
//        nameTextfield.skeletonableView()
//        surnameTextField.skeletonableView()
//        bioTextView.skeletonableView()
//        datePicker.skeletonableView()
//        bioLabel.skeletonableView()
//        dateOfBirthLabel.skeletonableView()
//        buttonChooseImage.skeletonableView()
//
//        bioTextView.layer.borderColor = UIColor.systemGray5.cgColor
//        bioTextView.layer.borderWidth = 1
//    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        guard let userProfileData = getProfileData() else {
            self.sendOkAlert(message: Constants.Alerts.pleaseEnterInfoMessage)
            return
        }
            
        updateUser(with: userProfileData)
    }
        
    func updateUser(with userUpdateData: UserProfileUpdateData) {
        let defaultAction = UIAlertAction(title: Constants.Alerts.defaultActionTitle, style: .default, handler: {_ -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        profileService.updateUser(with: userUpdateData) { result in
            switch result {
            case .success():
                self.sendAlert(message: Constants.Alerts.successfullyUpdatedMessage, action: defaultAction)
            case .failure:
                self.sendOkAlert(message: Constants.Alerts.wrongInputMessage)
            }
        }
    }
        
    func getProfileData() -> UserProfileUpdateData? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.Strings.dateFormatDateOfBirth
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
            gender: "1",
            profile_pic: "empty",
            bio: bio
        )
        return profileData
    }
}

