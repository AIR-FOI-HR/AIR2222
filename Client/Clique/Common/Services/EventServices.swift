//
//  EventServices.swift
//  Clique
//
//  Created by Infinum on 25.11.2022..
//

import Alamofire
import UIKit

final class EventServices {
    
    func getEvent(completion: @escaping(Result<[Event], Error>) -> Void) {
        AF.request(Constants.Service.eventsURL, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Event].self) { response in
                switch response.result {
                case .success(let eventResponse):
                    completion(.success(eventResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func getLogUserEvents(completion: @escaping(Result<[Event], Error>) -> Void) {
        AF.request(Constants.Service.createdUserEventsURL,
                   method: .get,
                   headers: Constants.Service.requestHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Event].self) { response in
                switch response.result {
                    case .success(let eventResponse):
                        completion(.success(eventResponse))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
    
    func getRegisteredEvents(completion: @escaping(Result<[Event], Error>) -> Void) {
        AF.request(Constants.Service.userRegisteredEvents,
                   method: .get,
                   headers: Constants.Service.requestHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Event].self) { response in
                switch response.result {
                    case .success(let eventResponse):
                        completion(.success(eventResponse))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
    }
}
