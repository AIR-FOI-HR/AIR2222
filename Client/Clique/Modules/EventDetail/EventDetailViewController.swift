//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController{
    var eventGet : Event?
    
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
        
        guard let _event = eventGet else { return }
        //title = _event.eventName
        _eventName.text = _event.eventName
        _eventDescription.text = _event.eventDescription
        _eventCreator.text = _event.eventCreator.userName + " " + _event.eventCreator.userSurname
        _eventLocation.text = _event.eventLocation
        _eventTimestamp.text = _event.eventTimestamp
        _eventParticipantsNum.text = String(_event.eventParticipantNumber)
        if let price = _event.eventCost{
            _eventCost.text = price == 0 ? "FREE" : String(price)
        } else {
            _eventCost.text = "FREE"
        }
        _eventCategory.text = _event.eventCategory
    }
}
