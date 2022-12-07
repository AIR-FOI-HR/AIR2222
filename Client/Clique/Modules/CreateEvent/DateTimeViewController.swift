//
//  DateTimeViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit

class DateTimeViewController: UIViewController {
    @IBOutlet private weak var chosenDateTime: UIDatePicker!
    
    var selectedCategory: String = ""
    var eventName: String = ""
    var participantNumber: String = ""
    var eventCost: String = ""
    var currency: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Date and Time"
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendDateTime" {
            
            let controller = segue.destination as! LocationViewController
            controller.selectedCategory = selectedCategory
            controller.eventName = eventName
            controller.participantNumber = participantNumber
            controller.eventCost = eventCost
            controller.currency = currency
            controller.chosenDateTime = chosenDateTime.date.description
        }
    }
}
