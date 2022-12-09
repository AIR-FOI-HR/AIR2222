//
//  LocationViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit

class LocationViewController: UIViewController {
   
    var createEventObject = CreateEventObject()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "ShortDescription", bundle: nil).instantiateInitialViewController() as? ShortDescriptionViewController
        else { return }
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }
}
