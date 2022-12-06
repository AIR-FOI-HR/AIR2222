//
//  Constants.swift
//  Clique
//
//  Created by Infinum on 21.11.2022..
//

import Foundation
import Alamofire

enum Constants {
    
    enum Service {
        private static let baseURL = "https://cliquewebservice20221115180920.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        static let profileGetUserURL = baseURL.appending("User")
        static let profileUpdateURL = baseURL.appending("User/UpdateUserData")
        static let passwordUpdateURL = baseURL.appending("User/UpdateUserPassword")
    }
}
