import Alamofire
import UIKit

final class RegisterService {
    
    func register(
        with entries: RegisterEntries,
        completion: @escaping(Result<Void, Error>) -> Void) {
            AF
            .request(Constants.Service.registerURL,
                       method: .post,
                       parameters : entries,
                       encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300).response {
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

