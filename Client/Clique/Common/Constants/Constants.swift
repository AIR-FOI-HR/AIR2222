//
//  Constants.swift
//  Clique
//
//  Created by Infinum on 21.11.2022..
//

import Foundation

enum Constants {
    
    enum Service {
        private static let baseURL = "https://cliquewebservice20221115180920.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        static let categoriesURL = baseURL.appending("Event/GetCategories")
        static let currenciesURL = baseURL.appending("Event/GetCurrencies")
        static let createEventURL = baseURL.appending("Event/CreateNewEvent")
    }
    
    enum Alerts {
        static let successfullyUpdatedMsg = "Succesfully updated."
        static let pleaseEnterInfoMsg = "Please enter all required information."
        static let successRegisterMsg = "Successfully registrated."
        static let passwordsDontMatchMsg = "Passwords don't match."
        static let wrongInputMsg = "Wrong input."
        static let successfullyCreatedEventMsg = "Successfully created event!"
        static let pleaseEnterShortDescriptionMsg = "Please enter short description."
    }
    
    enum DateFormats {
        static let dateFormatterPrint = "yyyy-MM-dd HH:mm"
        static let dateFormatterAPI = "yyyy-MM-dd'T'HH:mm:SS'Z'"
    }
}
