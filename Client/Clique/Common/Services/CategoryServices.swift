//
//  FilterServices.swift
//  Clique
//
//  Created by Infinum on 15.12.2022..
//

import Foundation
import UIKit
import Alamofire

final class CategoryServices {
    
    func getCategory(completion: @escaping(Result<[Category], Error>) -> Void) {
        AF.request(Constants.Service.categoriesURL, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Category].self) { response in
                switch response.result {
                case .success(let categoryResponse):
                    
                    completion(.success(categoryResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
