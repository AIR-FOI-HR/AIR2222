//
//  Functions.swift
//  Clique
//
//  Created by Infinum on 09.12.2022..
//

import UIKit

enum Functions {
    
    enum Alerts {
        static func alert(Message: String,viewController: UIViewController){
            let alertController = UIAlertController(title: nil, message: Message , preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: Constants.Alerts.defaultActionTitle, style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
