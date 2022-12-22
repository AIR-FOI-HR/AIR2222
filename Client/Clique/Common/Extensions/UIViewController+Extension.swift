//
//  UIViewController+Extension.swift
//  Clique
//
//  Created by Infinum on 10.12.2022..
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showAlert(
            title: String = "",
            message: String,
            actions: [UIAlertAction],
            animated: Bool = true
    ) {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )

            actions.forEach { alertController.addAction($0) }
            present(alertController, animated: animated)
    }

    func showOKAlert(
            title: String = "",
            message: String,
            actionTitle: String? = Constants.Alerts.defaultOKActionTitle,
            animated: Bool = true
    ) {
            let action = UIAlertAction(title: actionTitle, style: .cancel)
            showAlert(title: title, message: message, actions: [action], animated: animated)
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
