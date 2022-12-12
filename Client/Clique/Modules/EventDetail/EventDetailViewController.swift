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
    @IBOutlet private var _buttonJoinEvent: UIButton!
    
    
    private var _eventServices = EventServices()
    private var _status = 0
    private var _event_Id = "0"
    private var _alertMessage = ""
    private var _didItEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        _checkUserStatusOnEvent()
        _setupUI()
    }
}

private extension EventDetailViewController {
    
    func _setupUI() {
        guard let _event = self.event else { return }
        _event_Id = String(_event.id)
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
        _buttonJoinEvent.addTarget(self, action: #selector(_registerOnEvent), for: .touchUpInside)
        if(_stringToTimeStamp(timeString: _event.timestamp) < NSDate().timeIntervalSince1970){
            _didItEnd = true
        }
        _checkUserStatusOnEvent()
    }
    
    func _stringToTimeStamp(timeString: String) -> TimeInterval {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatterGet.date(from: timeString)
        print(date!.timeIntervalSince1970)
        return date!.timeIntervalSince1970
    }
    
    func _checkUserStatusOnEvent(){
        _eventServices.checkUserStatusOnEvent(event_id: _event_Id){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let status):
                _self._status = status
                _self._activateButton()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func _activateButton(){
        if(!_didItEnd){
            if(_status == 1 || _status == 3){
                        _buttonJoinEvent.setTitle("Join", for: .normal)
                        _buttonJoinEvent.isHidden = false
                        _alertMessage = "Are you sure you want to join this event?"
                    } else if(_status == 2) {
                        _buttonJoinEvent.setTitle("Cancel", for: .normal)
                        _buttonJoinEvent.isHidden = false
                        _alertMessage = "Are you sure you want to cancel this event?"
                    }
        } else if(_didItEnd && _status == 2) {
            print("Ovdje bi trebalo ici ocjenjivanje")
        } else {
            _buttonJoinEvent.isHidden = true
        }
    }
    
    @objc func _registerOnEvent(){
        let refreshAlert = UIAlertController(title: "Confirmation", message: _alertMessage, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in self.reg()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func reg(){
        _eventServices.registerOnEvent(event_id: _event_Id, status: _status){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                print(success)
                _self._status = success
                _self._activateButton()
            case .failure(let error):
                print(error)
            }
        }
    }
}
