//
//  LocationViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//
import UIKit
import IQKeyboardManagerSwift

class LocationViewController: UIViewController {
   
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    var createEventObject = CreateEventObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "ShortDescription", bundle: nil).instantiateInitialViewController() as? ShortDescriptionViewController
        else { return }
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }
}
