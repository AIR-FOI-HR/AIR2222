import Alamofire
import UIKit

struct RegisterEntries : Codable {

    let email : String
    let password : String
    let name: String
    let surname: String
}


final class RegisterService {
    
    func register(
        with entries: RegisterEntries,
        completionHandler: @escaping(Bool)->()){
            
            AF.request(Constants.Service.registerURL,
                       method: .post,
                       parameters : entries,
                       encoder: JSONParameterEncoder.default
            ).validate(statusCode: 200..<300).response{
                response in
                switch response.result {
                case .success(_):
                    completionHandler(true)
                case .failure(_):
                    completionHandler(false)
                    
                }
            }
        }
    
}

