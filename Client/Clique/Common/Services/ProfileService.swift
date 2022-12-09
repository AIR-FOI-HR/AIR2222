//
//  ProfileService.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import UIKit
import Alamofire

final class ProfileService {
    func getUser(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        AF.request(Constants.Service.profileGetUserURL,
                   method: .get,
                   headers: Constants.Service.requestHeaders())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: UserProfile.self) {
                dataResponse in
                switch dataResponse.result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func updateUser(
        with entries: UserProfileUpdateData,
        completion: @escaping(Result<Void, Error>) -> Void) {
            AF.request(Constants.Service.profileUpdateURL,
                       method: .post,
                       parameters : entries,
                       encoder: JSONParameterEncoder.default,
                       headers: Constants.Service.requestHeaders()
            ).validate(statusCode: 200..<300)
            .response {
                response in
                debugPrint(response)
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
