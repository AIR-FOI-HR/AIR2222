//
//  EventServices.swift
//  Clique
//
//  Created by Infinum on 25.11.2022..
//

import Alamofire
import UIKit

final class EventServices{
    
    func getEvent(completion: @escaping(Result<[Event], Error>) -> Void){
        AF.request(Constants.Service.eventsURL, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil, interceptor: nil)
            .validate(statusCode: 200..<300).responseData { response in
                switch response.result{
                case .success(_):
                    do{
                        var events: [Event] = []
                        var eventGets: [EventGet] = []
                        let data = response.data
                        let decoder = JSONDecoder()
                        let event = try decoder.decode(EventGet.self, from: data!)
                        debugPrint(event)
                        eventGets.append(event)
                        events = event.events
                        debugPrint(events)
                        completion(.success(events))
                    }catch{
                        print(error)
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
}
