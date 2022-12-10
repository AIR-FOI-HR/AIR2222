//
//  CreateEventOverviewViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//
import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class CreateEventOverviewViewController: UIViewController {
    
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var eventNameLabel: UILabel!
    @IBOutlet private var participantNumberLabel: UILabel!
    @IBOutlet private var eventCostLabel: UILabel!
    @IBOutlet private var chosenDateTimeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var shortDescriptionTextView: UITextView!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var postButton: UIButton!

    private let createEventService = CreateEventService()
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    var createEventObject = CreateEventObject()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        categoryLabel.text = createEventObject.categoryName
        eventNameLabel.text = createEventObject.eventName
        participantNumberLabel.text = createEventObject.participantsCount
        eventCostLabel.text = createEventObject.cost
        chosenDateTimeLabel.text = createEventObject.eventTimeStampPrint
        locationLabel.text = "Proba"
        shortDescriptionTextView.text = createEventObject.description
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
            let message = isSuccess ? Constants.Alerts.successfullyCreatedEventMessasge : Constants.Alerts.wrongInputMessasge
            Functions.Alerts.alert(message: message, viewController: self)
            Functions.Animations.stopAnimation(loading: self.loading)
        }
    }
    
    func getCreateEventEntries() -> CreateEventEntries? {

        let entries = CreateEventEntries(
            name: createEventObject.eventName,
            location: "lokacija",
            timeStamp: createEventObject.eventTimeStampAPI,
            participantsCount: createEventObject.participantsCount,
            cost: createEventObject.cost,
            currency: createEventObject.currencyId,
            category: createEventObject.categoryId,
            description: createEventObject.description
        )
        return entries
    }
}
    
    

