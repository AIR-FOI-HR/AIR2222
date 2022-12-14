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
    @IBOutlet private var bioTextView: UITextView!
    @IBOutlet private var characterCountLabel: UILabel!
    
    private let profileService = ProfileService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
        imageProfile.rounded()

        imageProfile.skeletonableView()
        emailTextField.skeletonableView()
        nameTextfield.skeletonableView()
        surnameTextField.skeletonableView()
        bioTextView.skeletonableView()
        datePicker.skeletonableView()
        dateOfBirthLabel.skeletonableView()
        buttonChooseImage.skeletonableView()
        
        bioTextView.delegate = self
        bioTextView.layer.borderColor = UIColor.systemGray5.cgColor
        bioTextView.layer.borderWidth = 1
    }
    
    private func getUser() {
        profileService.getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.imageProfile.stopSkeletonAnimation()
                self?.emailTextField.stopSkeletonAnimation()
                self?.nameTextfield.stopSkeletonAnimation()
                self?.surnameTextField.stopSkeletonAnimation()
                self?.bioTextView.stopSkeletonAnimation()
                self?.datePicker.stopSkeletonAnimation()
                self?.view.hideSkeleton(reloadDataAfter: true,
                                       transition: .crossDissolve(0.5))
                
                self?.nameTextfield.text = user.name
                self?.surnameTextField.text = user.surname
                self?.emailTextField.text = user.email
                self?.bioTextView.text = user.bio
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
        
    func updateUser(with userUpdateData: User) {
        let defaultAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: {_ -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        profileService.updateUser(with: userUpdateData) { result in
            switch result {
            case .success():
                self.sendOKCancelAlert(message: Constants.Alerts.successfullyUpdatedMessage,
                                        actions: [defaultAction])
            case .failure:
                self.sendOkAlert(message: Constants.Alerts.wrongInputMessage)
            }
        }
    }
        
    func getProfileData() -> User? {
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
            
        let profileData = User(
            id: nil,
            name: name,
            surname: surname,
            email: email,
            contact: "empty",
            birthDate: selectedDate,
            profilePicture: "empty",
            bio: bio
        )
        return profileData
    }
}

extension ProfileEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let countdown = (251 - bioTextView.text.count) - updatedText.count
        let text = "Write a short bio. You have \(countdown) characters remaining."
        let range = (text as NSString).range(of: "\(countdown)")
        let attributedString = NSMutableAttributedString(string:text)
        if countdown == 0 {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor.systemRed, range: range)
        } else if countdown > 0 && countdown < 11 {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor.systemYellow , range: range)
        } else {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: UIColor.systemGreen , range: range)
        }
        characterCountLabel.attributedText = attributedString
        return updatedText.count <= 250
    }
}
