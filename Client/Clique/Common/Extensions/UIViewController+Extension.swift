//
//  UIViewController+Extension.swift
//  Clique
//
//  Created by Infinum on 10.12.2022..
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func sendOkAlert(
        with title: String = "",
        message: String
    ) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.Alerts.deafultActionTitle, style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func sendAlert(
        with title: String = "",
        message: String,
        action: UIAlertAction
    ) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func startAnimation(
        loading: NVActivityIndicatorView,
        view: UIView
    ) {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
        loading.widthAnchor.constraint(equalToConstant: 40),
        loading.heightAnchor.constraint(equalToConstant: 40),
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 350),
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
    }
    
    func stopAnimation(loading: NVActivityIndicatorView) {
        loading.stopAnimating()
    }
}
