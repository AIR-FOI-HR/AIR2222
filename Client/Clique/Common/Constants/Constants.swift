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
        private static let baseURL = "https://cliquewebservice20221128214150.azurewebsites.net/api/"
        static let registerURL = baseURL.appending("Authentication/RegisterUser")
        static let loginURL = baseURL.appending("Authentication/LoginUser")
        static let eventsURL = baseURL.appending("Event/GetAllEvents")
        static let eventRegistrationURL = baseURL.appending("EventRegister/RegisterOnEvent")
        
        static func requestHeaders() -> HTTPHeaders {
            var headers: HTTPHeaders = [
                "Accept": "application/json",
                "Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKV1RTZXJ2aWNlQWNjZXNzVG9rZW4iLCJqdGkiOiIyZjYwMzk4Zi0wNjk5LTRmN2UtYTY5Zi1jMDgzYWFiN2ZiYmQiLCJpYXQiOiIxMi8xNC8yMDIyIDU6MTA6NDcgUE0iLCJVc2VySWQiOiI0IiwiRW1haWwiOiJtdnVrQGdtYWlsLmNvbSIsImV4cCI6MTY3MTA0MTQ0NywiaXNzIjoiSldUQXV0aGVudGljYXRpb25TZXJ2ZXIiLCJhdWQiOiJKV1RDbGlxdWVVc2VycyJ9.PJanUMEcCHfatcj28EMzbs5yOhzzCP9bPgkECr69zRc"

            ]
            //if let token = UserStorage.token {
            //        headers
            //}
            
            return headers
        }
        
    }
    
    enum Labels {
        static let labelFree = "FREE"
    }
    
    enum Storyboards {
        static let eventListTableViewCell = "EventListTableViewCell"
        static let eventDetail = "EventDetail"
    }
}
