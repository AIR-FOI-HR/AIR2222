//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit
import Cosmos

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
    @IBOutlet private var _ratingView: CosmosView!
    
    
    private var eventServices = EventServices()
    private var session = Session()
    private var status = 0
    private var alertMessage = ""
    private var eventStatus = Event.status.done
    
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
        _eventName.text = event.name
        _eventDescription.text = event.description
        _eventCreator.text = event.creator.name + " " + event.creator.surname
        _eventLocation.text = event.location
        _eventTimestamp.text = event.timeStampToString(timestamp: event.timestamp)
        _eventParticipantsNum.text = String(event.participantNumber)
        let currency = event.currency
        if let price = event.cost {
            _eventCost.text = price == 0 ? Constants.Labels.labelFree : String(price) + " " + (currency ?? "")
        } else {
            _eventCost.text = Constants.Labels.labelFree
        }
        _eventCategory.text = event.category
        
        _ratingView.settings.fillMode = .half
        _ratingView.settings.minTouchRating = 0.5
        _ratingView.rating = 0
        
        if event.participants.count <= event.participantNumber {
            checkUserStatusOnEvent(participants: event.participants)
        }
    }
    
    func checkUserStatusOnEvent(participants: [Participant?]) {
        var id = session.getUserId()
        if let participant = participants.first(where: {$0?.user.id == id}) {
            status = participant?.userStatusOnEvent ?? 0
            activateButton()
        }
    }
    
    func activateButton() {
        eventStatus = event.didItEnd(timestamp: event.timestamp)
        switch(eventStatus) {
            case .pending:
                _ratingView.isHidden = true
                _buttonJoinEvent.addTarget(self, action: #selector(registerToEventAlert), for: .touchUpInside)
                _buttonJoinEvent.isHidden = false
                switch status {
                    case 1:
                        _buttonJoinEvent.setTitle("Join", for: .normal)
                        alertMessage = Constants.Alerts.joinEventMessage
                    case 2:
                        _buttonJoinEvent.setTitle("Leave", for: .normal)
                        alertMessage = Constants.Alerts.cancelEventMessage
                    case 3:
                        _buttonJoinEvent.setTitle("You cannot rejoin event", for: .normal)
                        _buttonJoinEvent.isEnabled = false
                    default:
                        _buttonJoinEvent.isHidden = true
                }
            case .done:
                if(status == 2){
                    _ratingView.isUserInteractionEnabled = false
                    getRatedEvent()
                }
            default:
                _buttonJoinEvent.isHidden = true
        }
    }
    
    func setCosmosRating() {
        _ratingView.isHidden = false
        _buttonJoinEvent.isHidden = false
        if _ratingView.rating == 0 {
            _ratingView.isUserInteractionEnabled = true
            _buttonJoinEvent.addTarget(self, action: #selector(rateEventAlert), for: .touchUpInside)
            _buttonJoinEvent.setTitle("Rate", for: .normal)
        } else {
            _buttonJoinEvent.setTitle("Event already rated", for: .normal)
            _buttonJoinEvent.isEnabled = false
            let rating = _ratingView.rating
            _ratingView.isUserInteractionEnabled = false
            _ratingView.rating = rating
        }
    }
    
    @objc func registerToEventAlert() {
        let okAction = UIAlertAction(title: Constants.Alerts.defaultOKActionTitle,
                                     style: .default,
                                     handler: {(action: UIAlertAction!) in self.callRegisterToEventService()})
        let cancelAction = UIAlertAction(title: Constants.Alerts.defaultCancelActionTitle,
                                         style: .default,
                                         handler: .none)
        showAlert(message: alertMessage, actions: [okAction, cancelAction])
    }
    
    @objc func rateEventAlert() {
        eventServices.rateEvent(event_id: event.id, rating: _ratingView.rating){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                _self.showAlert(message: success, actionTitle: Constants.Alerts.defaultOKActionTitle)
                _self.setCosmosRating()
            case .failure(_):
                _self.showAlert(message: Constants.Alerts.rateEventError, actionTitle: Constants.Alerts.defaultOKActionTitle)
            }
        }
    }
    
    func callRegisterToEventService() {
        eventServices.registerToEvent(event_id: event.id, status: status){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                _self.status = success
                _self.activateButton()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getRatedEvent() {
        eventServices.getRatedEvent(event_id: event.id) { [weak self] result in
            guard let _self = self else { return }
            switch result {
            case .success(let success):
                _self._ratingView.rating = success
                _self.setCosmosRating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
