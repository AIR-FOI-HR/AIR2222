//
//  ProfileService.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import UIKit
import Alamofire

final class ProfileService {
    
    func getUser(completion: @escaping(Result<[UserProfile], Error>) -> Void){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer"
            + " " + "\(UserStorage.token)",
            "Accept": "application/json"
        ]
        AF.request(Constants.Service.profileIDUrl, method: .get, headers: headers)
            .validate(statusCode: 200..<300).responseData {
                response in
                switch response.result {
                case .success(_):
                    do{
                        var profile: [UserProfile]
                        let object = response.data
                        let decoder = JSONDecoder()
                        let user =  try decoder.decode(UserGet.self, from: object!)
                        profile = user.users
                        completion(.success(profile))
                        debugPrint(profile)
                    }
                    catch{
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}
