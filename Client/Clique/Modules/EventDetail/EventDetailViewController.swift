//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit
import JWTDecode
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
    @IBOutlet private var buttonJoinEvent: UIButton!
    @IBOutlet private var cosmosView: CosmosView!
    
    
    private var eventServices = EventServices()
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
        
        cosmosView.settings.fillMode = .half
        cosmosView.settings.minTouchRating = 0.5
        cosmosView.rating = 0
        
        if(event.participants.count <= event.participantNumber)
        {
            checkUserStatusOnEvent(participants: event.participants)
        }

        
    }
    
    func didItEnd(timestamp: TimeInterval) -> Event.status {
        let currentTimestamp = Date().timeIntervalSince1970
        if(currentTimestamp < timestamp) {
            return .pending
        } else if(currentTimestamp > timestamp) {
            return .done
        } else {
            return .inProgress
        }
    }
    
    func checkUserStatusOnEvent(participants: [Participant?]){
        var id = 0
        do {
            let jwt = try decode (jwt: UserStorage.token!)
            if let userId = jwt["UserId"].string {
                id = Int(userId) ?? 0
            }
        } catch {
            return
        }
        participants.forEach{participant in
            if(participant?.user.id  == id) {
                status = participant?.status ?? 0
                activateButton()
                return
            }
        }
    }
    
    func activateButton(){
        eventStatus = didItEnd(timestamp: event.timestamp)
        if(eventStatus == Event.status.pending){
            cosmosView.isHidden = true
            buttonJoinEvent.addTarget(self, action: #selector(registerToEventAlert), for: .touchUpInside)
            buttonJoinEvent.isHidden = false
            if(status == 1){
                buttonJoinEvent.setTitle("Join", for: .normal)
                alertMessage = Constants.Alerts.joinEventMessage
            } else if(status == 2) {
                buttonJoinEvent.setTitle("Leave", for: .normal)
                alertMessage = Constants.Alerts.cancelEventMessage
            } else if(status == 3) {
                buttonJoinEvent.setTitle("You cannot rejoin event", for: .normal)
                buttonJoinEvent.isEnabled = false
            }
        } else if(eventStatus == Event.status.done && status == 2) {
            cosmosView.isUserInteractionEnabled = false
            getRatedEvent()
        } else {
            buttonJoinEvent.isHidden = true
        }
    }
    
    func setCosmosRating() {
        cosmosView.isHidden = false
        buttonJoinEvent.isHidden = false
        if(cosmosView.rating == 0) {
            cosmosView.isUserInteractionEnabled = true
            buttonJoinEvent.addTarget(self, action: #selector(rateEventAlert), for: .touchUpInside)
            buttonJoinEvent.setTitle("Rate", for: .normal)
        } else {
            buttonJoinEvent.setTitle("Event already rated", for: .normal)
            buttonJoinEvent.isEnabled = false
            let rating = cosmosView.rating
            cosmosView.isUserInteractionEnabled = false
            cosmosView.rating = rating
        }
    }
    
    @objc func registerToEventAlert(){
        let refreshAlert = UIAlertController(title: Constants.Alerts.confirmationTitleMessage, message: alertMessage, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: Constants.Alerts.defaultOKActionTitle, style: .default, handler: { (action: UIAlertAction!) in self.callRegisterToEventService()
        }))

        refreshAlert.addAction(UIAlertAction(title: Constants.Alerts.defaultCancelActionTitle, style: .cancel, handler: { (action: UIAlertAction!) in
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func rateEventAlert(){
        eventServices.rateEvent(event_id: event.id, rating: cosmosView.rating){[weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                _self.sendOkAlert(message: success)
                _self.setCosmosRating()
            case .failure(_):
                _self.sendOkAlert(message: Constants.Alerts.rateEventError)
            }
        }
    }
    
    func callRegisterToEventService(){
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
    
    func getRatedEvent(){
        eventServices.getRatedEvent(event_id: event.id){ [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let success):
                _self.cosmosView.rating = success
                _self.setCosmosRating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
