import Alamofire
import UIKit

final class CreateEventService {
    
    func getCategories(
        completion: @escaping(Result<[Category], Error>) -> Void) {
        AF
        .request(Constants.Service.categoriesURL, method: .get)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [Category].self) {
            response in
            switch response.result {
            case .success(let categoryResponse):
                completion(.success(categoryResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrencies(
        completion: @escaping(Result<[Currency], Error>) -> Void) {
        AF
        .request(Constants.Service.currenciesURL, method: .get)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [Currency].self) {
            response in
            switch response.result {
            case .success(let currencyResponse):
                completion(.success(currencyResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createEvent(
        with entries: CreateEventEntries,
        completion: @escaping(Result<Void, Error>) -> Void) {
        AF
        .request(Constants.Service.createEventURL,
                 method: .post,
                 parameters: entries,
                 encoder: JSONParameterEncoder.default,
                 headers: Constants.Service.requestHeaders())
        .validate(statusCode: 200..<300)
        .response{
            response in
            switch response .result {
            case.success(_):
                completion(.success(()))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
