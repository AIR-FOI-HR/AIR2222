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
        private static let baseURL = "https://cliquewebservice20221128214150.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        static let profileGetUserURL = baseURL.appending("User")
        static let profileUpdateURL = baseURL.appending("User/UpdateUserData")
        static let passwordUpdateURL = baseURL.appending("User/UpdateUserPassword")
        static let categoriesURL = baseURL.appending("Event/GetCategories")
        static let currenciesURL = baseURL.appending("Event/GetCurrencies")
        static let createEventURL = baseURL.appending("Event/CreateNewEvent")
        static let eventsURL = baseURL.appending("Event/GetAllEvents")
        static let eventRegistrationURL = baseURL.appending("EventRegister/RegisterOnEvent")
        static let rateEventURL = baseURL.appending("Ratings/RateEvent")
        static let APIkey = "AIzaSyC0NNY4L9uG_Vbn3oEyy-141uhKQzDb_VU"
       
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
        static let pleaseEnterInfoMessage = "Please enter all required information."
        static let successRegisterMessage = "Successfully registrated."
        static let passwordsDontMatchMessage = "Passwords don't match."
        static let wrongInputMessage = "Wrong input."
        static let defaultOKActionTitle = "OK"
        static let defaultCancelActionTitle = "Cancel"
        static let wantToLogOutMessage = "Are you sure you want to log out?"
        static let wrongCredentialsMessage = "E-mail or password is incorrect."
        static let pleaseChooseLocationMessasge = "Please choose a location."
        static let pleaseEnterShortDescriptionMessasge = "Please enter short description."
        static let successfullyCreatedEventMessasge = "Successfully created event!"
        static let confirmationTitleMessage = "Confirmation"
        static let joinEventMessage = "Are you sure you want to join this event?"
        static let cancelEventMessage = "Are you sure you want to cancel this event?"
    }
   
    enum DateFormats {
        static let dateFormatClient = "yyyy-MM-dd HH:mm"
        static let dateFormatAPI = "yyyy-MM-dd'T'HH:mm:SS'Z'"
        static let dateFormatDateOfBirth = "yyyy-MM-dd"
    }
    
    enum Labels {
        static let labelFree = "FREE"
    }
    
    enum Storyboards {
        static let eventListTableViewCell = "EventListTableViewCell"
        static let eventDetail = "EventDetail"
    }
}

