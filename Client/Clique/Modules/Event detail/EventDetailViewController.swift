//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController{
    var eventGet : Event!
    
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
    
    func _setupUI(){
        
        guard let _event = eventGet else {return}
        //title = _event.eventName
        _eventName.text = _event.eventName
        _eventDescription.text = _event.eventDescription
        _eventCreator.text = _event.eventCreator.userName + " " + _event.eventCreator.userSurname
        _eventLocation.text = _event.eventLocation
        _eventTimestamp.text = _event.eventTimestamp
        _eventParticipantsNum.text = String(_event.eventParticipantNumber)
        if (_event.eventCost == 0 ){
            _eventCost.text = "FREE"
        }
        else{
            _eventCost.text = String(_event.eventCost!)
        }
        _eventCategory.text = _event.eventCategory
    }
}
