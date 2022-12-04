//
//  UIImageView+Extension.swift
//  Clique
//
//  Created by Infinum on 17.11.2022..
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    func setupImage(with url: String?) {
        guard let _url = url else { return }
        AF.request(_url)
            .responseImage { [weak self] response in
                guard let _self = self else { return }
                if
                    case.success (let image) = response.result {_self.image = image
                    
            }
        }
    }
}
