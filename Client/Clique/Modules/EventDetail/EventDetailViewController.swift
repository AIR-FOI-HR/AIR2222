//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit
import JWTDecode

class EventDetailViewController: UIViewController {
    public var event : Event!
    
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
    
    
    private var eventServices = EventServices()
    private var status = 0
    private var _alertMessage = ""
    private var _didItEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    static func initializeDetailsViewController(with event: Event) -> UIViewController? {
        let storyboard = UIStoryboard(name: String(describing: "EventDetail"), bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as? EventDetailViewController
        viewController?.event = event
        return viewController
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
        _buttonJoinEvent.addTarget(self, action: #selector(_registerToEvent), for: .touchUpInside)
        if(_stringToTimeStamp(timeString: _event.timestamp) < NSDate().timeIntervalSince1970){
            _didItEnd = true
        }
        _checkUserStatusOnEvent(participants: _event.participants)
    }
    
    func _stringToTimeStamp(timeString: String) -> TimeInterval {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let date = dateFormatterGet.date(from: timeString)
        print(date!.timeIntervalSince1970)
        return date!.timeIntervalSince1970
    }
    
    func _checkUserStatusOnEvent(participants: [Participant?]){
        var id = 0
        do{
            let jwt = try decode (jwt: UserStorage.token!)
            if let userId = jwt["UserId"].string {
                id = Int(userId) ?? 0
            }
        }catch{
            return
        }
        participants.forEach{participant in
            if(participant?.user.id  == id) {
                status = participant?.status ?? 0
                _activateButton()
                return
            }
        }
    }
    
    func _activateButton(){
        if(!_didItEnd){
            if(status == 1 || status == 3){
                        _buttonJoinEvent.setTitle("Join", for: .normal)
                        _buttonJoinEvent.isHidden = false
                _alertMessage = Constants.Alerts.joinEventMessage
                    } else if(status == 2) {
                        _buttonJoinEvent.setTitle("Cancel", for: .normal)
                        _buttonJoinEvent.isHidden = false
                        _alertMessage = Constants.Alerts.cancelEventMessage
                    }
        } else if(_didItEnd && status == 2) {
            //TODO: Rating
        } else {
            _buttonJoinEvent.isHidden = true
        }
    }
    
    @objc func _registerToEvent(){
        let refreshAlert = UIAlertController(title: Constants.Alerts.confirmationTitleMessage, message: _alertMessage, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: { (action: UIAlertAction!) in self.callRegisterToEventService()
        }))

        refreshAlert.addAction(UIAlertAction(title: Constants.Alerts.defaultCancelActionTitle, style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    func callRegisterToEventService(){
        eventServices.registerToEvent(event_id: event.id, status: status){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                print(success)
                _self.status = success
                _self._activateButton()
            case .failure(let error):
                print(error)
            }
        }
    }
}
