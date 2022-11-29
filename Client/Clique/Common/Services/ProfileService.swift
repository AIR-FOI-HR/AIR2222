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
        AF.request(Constants.Service.profileURL, method: .get)
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
