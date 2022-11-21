
import Alamofire
import UIKit

struct RegisterEntries : Codable {

    let email : String
    let password : String
    let name: String
    let surname: String
    let contactNum: String
    let gender: Int
    let birthData: String
  
}

struct RegisterResponse : Codable {
    let status : String
    
}

final class RegisterService {
    
    func register(
            with entries: RegisterEntries,
            completionHandler: @escaping(Bool)->()){
    
                AF.request(Constants.Service.registerURL,
                           method: .post,
                           parameters : entries,
                           encoder: JSONParameterEncoder.default
                                ).responseDecodable(of: RegisterResponse.self){
                    response in
                    switch response.result {
                    case .success(let statusCode):
                        completionHandler(statusCode.status == "200 - OK")
                    case .failure(_):
                        completionHandler(false)
                        
                    }
                }
            }
}

