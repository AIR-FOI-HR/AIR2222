//
//  LoginServices.swift
//  Clique
//
//  Created by Infinum on 03.11.2022..
//

import Foundation
import Alamofire
import UIKit

struct LoginCredentials : Codable {
//    let user_id : Int
//    let name : String
//    let surname : String
    let email : String
//    let gender : String
    let password : String
    
}

struct LoginResponse : Codable {
    let token : String
    
}

final class LoginService {
    
    func login(
        with credentials: LoginCredentials,
        completion : @escaping(Result<LoginResponse, Error>) -> Void){
            AF.request("https://cliquewebservice20221115180920.azurewebsites.net/api/Authentication/LoginUser", method: .post, parameters : credentials, encoder: JSONParameterEncoder.default ).responseDecodable(of:LoginResponse.self){
                dataResponse in
                switch dataResponse.result{
                case .success(let token):
                    completion(.success(token))   
                case .failure(let error):
                    completion(.failure(error))
                }
            }
                    
        }
        
    }


