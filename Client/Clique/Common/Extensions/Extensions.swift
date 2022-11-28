//
//  Extensions.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import UIKit

extension UIImageView {
    
    func circleImage() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
