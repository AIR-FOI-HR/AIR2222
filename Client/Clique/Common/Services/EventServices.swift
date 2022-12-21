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
    
    func registerToEvent(event_id: Int, status: Int,
        completion: @escaping(Result<Int, Error>) -> Void) {
        AF.request(Constants.Service.eventRegistrationURL,
                   method: .post,
                   parameters: ["event_id": event_id,
                                "status": status],
                   encoding: JSONEncoding.default,
                   headers: Constants.Service.requestHeaders()
                   )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Int.self) { response in
                switch response.result {
                case .success(let status):
                    completion(.success(status))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func rateEvent(event_id: Int, rating: Double,
        completion: @escaping(Result<String, Error>) -> Void) {
        AF.request(Constants.Service.rateEventURL,
                   method: .post,
                   parameters: ["event_id": event_id,
                                "rating": rating],
                   encoding: JSONEncoding.default,
                   headers: Constants.Service.requestHeaders()
                   )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: String.self) { response in
                switch response.result {
                case .success(let status):
                    completion(.success(status))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
