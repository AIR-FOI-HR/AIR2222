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
        title = "Date and Time (2/5)"
        
        
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController else{
            return
        }
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let chosenDate = dateFormatter.string(from: chosenDateTime.date)
        
        if segue.identifier == "sendDateTime" {
            
            let controller = segue.destination as! LocationViewController
            controller.selectedCategory = selectedCategory
            controller.eventName = eventName
            controller.participantNumber = participantNumber
            controller.eventCost = eventCost
            controller.currency = currency
            controller.chosenDateTime = chosenDate
        }
    }
}
