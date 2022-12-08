//
//  SettingsService.swift
//  Clique
//
//  Created by Infinum on 01.12.2022..
//

import Foundation
import Alamofire

final class SettingsService {
    
    func changePassword (
        with entries: PasswordData,
        completionHandler: @escaping(Bool)->()){
            AF.request(Constants.Service.passwordUpdateURL,
                       method: .post,
                       parameters : entries,
                       encoder: JSONParameterEncoder.default, headers: Constants.Service.authorizationHeader()
            ).validate(statusCode: 200..<300)
                .response{
                response in
                debugPrint(response)
                switch response.result {
                case .success(_):
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                }
            }
        }
}
