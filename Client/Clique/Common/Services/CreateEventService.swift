import Alamofire
import UIKit

final class CreateEventService {
    
    func getCategories(completion: @escaping(Result<[Category], Error>) -> Void){
            AF.request(Constants.Service.categoriesURL, method: .get)
                .validate(statusCode: 200..<300).responseData {
                response in
                switch response.result {
                case .success(_):
                    do{
                        var categories: [Category] = []
                        let object = response.data
                        let decoder = JSONDecoder()
                        let category =  try decoder.decode([Category].self, from: object!)
                        categories = category
                        completion(.success(categories))
                    }
                    catch{
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func getCurrencies(completion: @escaping(Result<[Currency], Error>) -> Void){
        AF.request(Constants.Service.currenciesURL, method: .get)
                .validate(statusCode: 200..<300).responseData {
                response in
                switch response.result {
                case .success(_):
                    do{
                        var currencies: [Currency] = []
                        let object = response.data
                        let decoder = JSONDecoder()
                        let currency =  try decoder.decode([Currency].self, from: object!)
                        currencies = currency
                        completion(.success(currencies))
                    }
                    catch{
                        return
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
    func createEvent(with entries: CreateEventEntries, completionHandler: @escaping(Bool) -> ()){
        let headers: HTTPHeaders = [
            "Authorization": "Bearer"
            + " " + "\(UserStorage.token)",
            "Accept" : "application/json"
        ]
        AF.request(Constants.Service.createEventURL, method: .post, parameters: entries, encoder: JSONParameterEncoder.default, headers: headers)
            .validate(statusCode: 200..<300).response{
            response in
            debugPrint(response)
            switch response .result {
            case.success(_):
                completionHandler(true)
            case.failure(_):
                debugPrint(response)
                completionHandler(false)
            }
        }
        
    }
}
