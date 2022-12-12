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
        static let userRegisteredOnEventURL = baseURL.appending("EventRegister/CheckIfUserIsSigned/")
        static let registerOnEventURL = baseURL.appending("EventRegister/RegisterOnEvent")
        
        static func requestHeaders() -> HTTPHeaders {
            var headers: HTTPHeaders = [
                "Accept": "application/json",
                "Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJKV1RTZXJ2aWNlQWNjZXNzVG9rZW4iLCJqdGkiOiIxNzg3MGJjMC1mMjhmLTRiZDQtODFmYy03NDU1N2I1YzgyODgiLCJpYXQiOiIxMi8xMi8yMDIyIDQ6MTc6MjMgUE0iLCJVc2VySWQiOiI0IiwiRW1haWwiOiJtdnVrQGdtYWlsLmNvbSIsImV4cCI6MTY3MDg2NTQ0MywiaXNzIjoiSldUQXV0aGVudGljYXRpb25TZXJ2ZXIiLCJhdWQiOiJKV1RDbGlxdWVVc2VycyJ9.7veMqC7UoJMq_sQmVH0JDmU4WhgKRNgSqp5k8pzP07E"

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
