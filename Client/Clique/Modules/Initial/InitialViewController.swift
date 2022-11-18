//
//  InitialViewController.swift
//  Clique
//
//  Created by Infinum on 30.10.2022..
//

import UIKit

class InitialViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet private weak var button: UIButton!
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Register" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
    

}
