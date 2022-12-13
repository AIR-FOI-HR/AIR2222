//
//  UIViewController+Extension.swift
//  Clique
//
//  Created by Infinum on 09.12.2022..
//

import UIKit

extension UIViewController {

    func sendOkAlert(
        with title: String = "",
        message: String
    ) {
        let alertController = UIAlertController(title: title, message: message ,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle,
                                     style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func sendAlert(
        with title: String = "",
        message: String,
        action: UIAlertAction
    ) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func sendOKCancelAlert(
        with title: String = "",
        message: String,
        actions: [UIAlertAction]
    ) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
}
