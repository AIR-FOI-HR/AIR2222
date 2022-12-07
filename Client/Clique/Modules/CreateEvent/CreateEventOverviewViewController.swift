//
//  CreateEventOverviewViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit

class CreateEventOverviewViewController: UIViewController {
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var participantNumberLabel: UILabel!
    @IBOutlet private weak var eventCostLabel: UILabel!
    @IBOutlet private weak var chosenDateTimeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    
    var selectedCategory: String = ""
    var eventName: String = ""
    var participantNumber: String = ""
    var eventCost: String = ""
    var chosenDateTime: String = ""
    var location: String = ""
    var shortDescription: String = ""
    var currency: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Overview"
        categoryLabel.text = selectedCategory
        eventNameLabel.text = eventName
        participantNumberLabel.text = participantNumber
        eventCostLabel.text = eventCost
        chosenDateTimeLabel.text = chosenDateTime
        locationLabel.text = location
        shortDescriptionLabel.text = shortDescription
        currencyLabel.text = currency
        
        
    }
    
    
}
