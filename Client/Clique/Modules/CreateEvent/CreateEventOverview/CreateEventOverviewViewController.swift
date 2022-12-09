//
//  CreateEventOverviewViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CreateEventOverviewViewController: UIViewController {
    
    var createEventObject = CreateEventObject()
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var eventNameLabel: UILabel!
    @IBOutlet private var participantNumberLabel: UILabel!
    @IBOutlet private var eventCostLabel: UILabel!
    @IBOutlet private var chosenDateTimeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var shortDescriptionLabel: UILabel!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var postButton: UIButton!

    private let createEventService = CreateEventService()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = createEventObject.categoryName
        eventNameLabel.text = createEventObject.eventName
        participantNumberLabel.text = createEventObject.participantsNumber
        eventCostLabel.text = createEventObject.cost
        chosenDateTimeLabel.text = createEventObject.eventTimeStampPrint
        locationLabel.text = "Proba"
        shortDescriptionLabel.text = createEventObject.description
        currencyLabel.text = createEventObject.currencyName
    }
    
    @IBAction func postButtonPressed(_sender: UIButton){
        guard let createEntries = getCreateEventEntries() else { return }
        Functions.Animations.startAnimation(loading: loading, view: view)
        createEvent(with: createEntries)
    }
    
    func createEvent(with createEventEntries: CreateEventEntries) {
        createEventService.createEvent(with: createEventEntries) {
            (isSuccess) in
            let message = isSuccess ? Constants.Alerts.successfullyCreatedEventMsg : Constants.Alerts.wrongInputMsg
            Functions.Alerts.alert(fwdMessage: message, viewController: self)
            Functions.Animations.stopAnimation(loading: self.loading)
        }
    }
    
    func getCreateEventEntries() -> CreateEventEntries? {

        let entries = CreateEventEntries(
            name: createEventObject.eventName,
            location: "lokacija",
            timeStamp: createEventObject.eventTimeStampAPI,
            participantsNumber: createEventObject.participantsNumber,
            cost: createEventObject.cost,
            currency: createEventObject.currencyId,
            category: createEventObject.categoryId,
            description: createEventObject.description
        )
        return entries
    }
}
    
    

