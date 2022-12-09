//
//  Extensions.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import UIKit
import SkeletonView

extension UIImageView {
    
    func circleImage() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}

extension UIView {
    
    func skeletonableView() {
        layer.masksToBounds = false
        self.isSkeletonable = true
        self.showAnimatedSkeleton(usingColor: .clouds,
                                          transition: .crossDissolve(0.5))
    }
}
