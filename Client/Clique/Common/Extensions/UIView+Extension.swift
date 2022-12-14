//
//  UIView+Extension.swift
//  Clique
//
//  Created by Infinum on 12.12.2022..
//

import UIKit
import SkeletonView

extension UIView {
    
    func skeletonableView() {
        self.isSkeletonable = true
        self.showAnimatedSkeleton(usingColor: .clouds,
                                  transition: .crossDissolve(0.5))
    }
}
