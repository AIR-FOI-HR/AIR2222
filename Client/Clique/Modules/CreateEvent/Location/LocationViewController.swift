//
//  LocationViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit

class LocationViewController: UIViewController {
   
    var selectedCategory: String = ""
    var eventName: String = ""
    var participantNumber: String = ""
    var eventCost: String = ""
    var currency: String = ""
    var chosenDateTime: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location (3/5)"
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "ShortDescription", bundle: nil).instantiateInitialViewController() as? ShortDescriptionViewController else{
            return
        }
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendLocation" {
            let controller = segue.destination as! ShortDescriptionViewController
            controller.selectedCategory = selectedCategory
            controller.eventName = eventName
            controller.participantNumber = participantNumber
            controller.eventCost = eventCost
            controller.currency = currency
            controller.chosenDateTime = chosenDateTime
            controller.location = "proba"
            }
    }
}
