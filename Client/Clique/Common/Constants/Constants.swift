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
        
        static func getToken() -> String {
            guard let token = UserStorage.token else { return "" }
            return token
        }
        
        static func authorizationHeader() -> HTTPHeaders {
            let header: HTTPHeaders = [
                "Authorization": "Bearer"
                + " " + "\(getToken())",
                "Accept": "application/json"
            ]
            return header
        }
    }
        enum Alerts {
            static let successfullyUpdatedMsg = "Successfully updated."
            static let pleaseEnterInfoMsg = "Please enter all required info."
            static let successRegisterMsg = "Successfully registrated"
            static let passwordDontMatchMsg = "Passwords don't match"
            static let wrongInputMsg = "Wrong input"
        }
        
        enum Strings {
            static let dateFormat = "yyyy-MM-dd"
        }
    }

