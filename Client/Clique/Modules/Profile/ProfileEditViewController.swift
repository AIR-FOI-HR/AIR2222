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
    
    
    private var imagePicker = UIImagePickerController()
    
    private let profileService = ProfileService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
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
    }
    
    private func getUser() {
        profileService.getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.nameTextfield.text = user.name
                self?.surnameTextField.text = user.surname
                self?.emailTextField.text = user.email
                self?.bioTextView.text = user.bio
//                self.imageProfile.stopSkeletonAnimation()
//                self.emailTextField.stopSkeletonAnimation()
//                self.nameTextfield.stopSkeletonAnimation()
//                self.surnameTextField.stopSkeletonAnimation()
//                self.bioTextView.stopSkeletonAnimation()
//                self.datePicker.stopSkeletonAnimation()
                
                self?.view.hideSkeleton(reloadDataAfter: true,
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
        
    func updateUser(with userUpdateData: UserProfile) {
        let defaultAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: {_ -> Void in
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
        
    func getProfileData() -> UserProfile? {
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
            
        let profileData = UserProfile(
            id: nil,
            name: name,
            surname: surname,
            email: email,
            contact: "empty",
            birth_data: selectedDate,
            profile_pic: "empty",
            bio: bio
        )
        return profileData
    }
    
    @IBAction func btnChooseImageOnClick(_ sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension ProfileEditViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage{
            self.imageProfile.image = editedImage
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}

