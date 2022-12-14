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
        static let getPlacesURL =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=%22Trakoscanska%22&key=AIzaSyC0NNY4L9uG_Vbn3oEyy-141uhKQzDb_VU"
        static let APIkey = "AIzaSyC0NNY4L9uG_Vbn3oEyy-141uhKQzDb_VU"
    }
    
    enum Alerts {
        static let successfullyUpdatedMessasge = "Succesfully updated."
        static let pleaseEnterInfoMessasge = "Please enter all required information."
        static let successRegisterMessasge = "Successfully registrated."
        static let passwordsDontMatchMessasge = "Passwords don't match."
        static let wrongInputMessasge = "Wrong input."
        static let successfullyCreatedEventMessasge = "Successfully created event!"
        static let pleaseEnterShortDescriptionMessasge = "Please enter short description."
        static let pleaseChooseLocationMessasge = "Please choose a location."
        static let deafultActionTitle = "OK"
    }
    
    enum DateFormats {
        static let dateFormatClient = "yyyy-MM-dd HH:mm"
        static let dateFormatAPI = "yyyy-MM-dd'T'HH:mm:SS'Z'"
    }
    
}
