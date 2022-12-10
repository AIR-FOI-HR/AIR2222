//
//  Functions.swift
//  Clique
//
//  Created by Infinum on 09.12.2022..
//

import UIKit
import NVActivityIndicatorView

enum Functions {
    
    enum Alerts {
        
        static func alert(message: String, viewController: UIViewController) {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: Constants.Alerts.deafultActionTitle, style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    enum Animations {
        
        static func startAnimation(loading: NVActivityIndicatorView, view: UIView) {
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
        
        static func stopAnimation(loading: NVActivityIndicatorView) {
            loading.stopAnimating()
        }
    }
}
