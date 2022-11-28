//
//  Constants.swift
//  Clique
//
//  Created by Infinum on 25.11.2022..
//

import Foundation


enum Constants {
    
    enum Service {
        private static let baseURL = "https://cliquewebservice20221115180920.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        
        static let eventsURL = baseURL.appending("Event/GetAllEvents")
    }

}
