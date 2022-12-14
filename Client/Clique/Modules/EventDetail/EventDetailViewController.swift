//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController {
    var event : Event?
    
    @IBOutlet private var _eventDescription: UILabel!
    @IBOutlet private var _eventName: UILabel!
    @IBOutlet private var _eventImage: UIImageView!
    @IBOutlet private var _eventCreator: UILabel!
    @IBOutlet private var _eventLocation: UILabel!
    @IBOutlet private var _eventTimestamp: UILabel!
    @IBOutlet private var _eventParticipantsNum: UILabel!
    @IBOutlet private var _eventCost: UILabel!
    @IBOutlet private var _eventCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
}

private extension EventDetailViewController {
    
    func _setupUI() {
        guard let _event = self.event else { return }
        _eventName.text = _event.name
        _eventDescription.text = _event.description
        _eventCreator.text = _event.creator.name + " " + _event.creator.surname
        _eventLocation.text = _event.location
        _eventTimestamp.text = _event.timestamp
        _eventParticipantsNum.text = String(_event.participantNumber)
        let currency = _event.currency
        if let price = _event.cost {
            _eventCost.text = price == 0 ? Constants.Labels.labelFree : String(price) + " " + (currency ?? "")
        } else {
            _eventCost.text = Constants.Labels.labelFree
        }
        
        _eventCategory.text = _event.category
    }
}
