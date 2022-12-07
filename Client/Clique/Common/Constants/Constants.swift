//
//  Constants.swift
//  Clique
//
//  Created by Infinum on 21.11.2022..
//

import Foundation
import Alamofire
import UIKit

enum Constants {
    
    enum Service {
        private static let baseURL = "https://cliquewebservice20221115180920.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        static let profileGetUserURL = baseURL.appending("User")
        static let profileUpdateURL = baseURL.appending("User/UpdateUserData")
        static let passwordUpdateURL = baseURL.appending("User/UpdateUserPassword")
        
        static let headers: HTTPHeaders = [
            "Authorization": "Bearer"
            + " " + "\(UserStorage.token!)",
            "Accept": "application/json"
        ]
    }
    
    enum Alerts {
        static func alert(fwdMessage: String,viewController: UIViewController){
            let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
        static let successfullyUpdatedMsg = "Successfully updated."
        static let pleaseEnterInfoMsg = "Please enter all required info."
        static let successRegisterMsg = "Successfully registrated"
        static let passwordDontMatchMsg = "Password don't match"
        static let wrongInputMsg = "Wrong input"
    }
}
