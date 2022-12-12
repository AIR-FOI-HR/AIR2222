//
//  Extensions.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import UIKit
import SkeletonView

extension UIImageView {
    
    func rounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
