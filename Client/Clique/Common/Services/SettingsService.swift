//
//  SettingsService.swift
//  Clique
//
//  Created by Infinum on 01.12.2022..
//

import Foundation
import Alamofire

final class SettingsService {
    
    func changePassword(
        with entries: PasswordData,
        completion: @escaping(Result<Void, Error>) -> Void) {
            AF.request(Constants.Service.passwordUpdateURL,
                       method: .post,
                       parameters : entries,
                       encoder: JSONParameterEncoder.default,
                       headers: Constants.Service.requestHeaders())
            .validate(statusCode: 200..<300)
            .response{
                response in
                switch response.result {
                case .success(_):
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
