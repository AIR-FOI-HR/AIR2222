//
//  Extensions.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import UIKit
import Alamofire
import AlamofireImage

extension UIImageView {
    
    func rounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
    func setup(with url: String?) {
        guard let _url = url else { return }
        AF.request(_url)
            .responseImage { [weak self] response in
            if case .success(let image) = response.result {
                self?.image = image
            }
        }
    }
}
