//
//  Functions.swift
//  Clique
//
//  Created by Infinum on 09.12.2022..
//

import UIKit

enum Functions {
    
    enum Alerts {
        static func alert(fwdMessage: String,viewController: UIViewController){
            let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
