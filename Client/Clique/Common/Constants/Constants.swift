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
       
        static func requestHeaders() -> HTTPHeaders {
            var headers: HTTPHeaders = [
                "Accept": "application/json"
            ]

            if let token = UserStorage.token {
                headers["Authorization"] = "Bearer \(token)"
            }

            return headers
        }
    }
    enum Alerts {
        static let successfullyUpdatedMessage = "Successfully updated."
        static let pleaseEnterInfoMessage = "Please enter all required info."
        static let successRegisterMessage = "Successfully registrated"
        static let passwordDontMatchMessage = "Passwords don't match"
        static let wrongInputMessage = "Wrong input"
        static let defaultOKActionTitle = "OK"
        static let defaultCancelActionTitle = "Cancel"
        static let wantToLogOutMessage = "Are you sure you want to log out?"
        static let wrongCredentialsMessage = "E-mail or password is incorrect"
    }
        
    enum Strings {
        static let dateFormatDateOfBirth = "yyyy-MM-dd"
    }
}

