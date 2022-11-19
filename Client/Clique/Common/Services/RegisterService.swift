
import Foundation
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
    let statusCode : String
    
}

final class RegisterService {
    
    func register(
        with entries: RegisterEntries, completionHandler: @escaping (Bool) -> ()){
            
            AF.request("https://cliquewebservice20221115180920.azurewebsites.net/api/Authentication/RegisterUser", method: .post, parameters : entries, encoder: JSONParameterEncoder.default ).response{
                response in
                debugPrint(response)
                switch response.result{
                case .success(let status):
                    do{
                        let json = try JSONSerialization.jsonObject(with: status!,options: [])
                        if response.response?.statusCode == 200{
                            completionHandler(true)
                        }else{
                            completionHandler(false)
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                        completionHandler(false)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(false)
                }
            }
                    
        }
        
    }

