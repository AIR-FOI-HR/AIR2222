//
//  InitialViewController.swift
//  Clique
//
//  Created by Infinum on 30.10.2022..
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Login" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   

}
