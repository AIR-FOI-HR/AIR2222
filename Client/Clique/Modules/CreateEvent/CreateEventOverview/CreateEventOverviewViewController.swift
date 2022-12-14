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
        categoryLabel.text = createEventObject.category?.name
        eventNameLabel.text = createEventObject.eventName
        participantNumberLabel.text = createEventObject.participantsCount
        eventCostLabel.text = createEventObject.cost
        chosenDateTimeLabel.text = createEventObject.eventTimeStampPrint
        locationLabel.text = createEventObject.eventLocation
        shortDescriptionTextView.text = createEventObject.description
        currencyLabel.text = createEventObject.currency?.abbreviation
    }
    
    @IBAction func postButtonPressed(_sender: UIButton){
        guard let createEntries = getCreateEventEntries() else { return }
        self.startAnimation(loading: loading, view: view)
        createEvent(with: createEntries)
        print(createEntries)
    }
    
    func createEvent(with createEventEntries: CreateEventEntries) {
        createEventService.createEvent(with: createEventEntries) { result in
            switch result {
            case .success() :
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {_ -> Void in
                    let storyboard = UIStoryboard(name: "TabBar" , bundle: nil)
                    if let viewController = storyboard.instantiateInitialViewController() {
                        viewController.modalPresentationStyle = .fullScreen
                        self.present(viewController, animated: true)
                    }
                })
                self.stopAnimation(loading: self.loading)
                self.sendAlert(message: Constants.Alerts.successfullyCreatedEventMessasge, action: defaultAction)
            case .failure :
                self.sendOkAlert(message: Constants.Alerts.wrongInputMessage)
                self.stopAnimation(loading: self.loading)
            }
        }
    }

    func getCreateEventEntries() -> CreateEventEntries? {
        guard
            let category = createEventObject.category?.id.description,
            let name = createEventObject.eventName,
            let location = createEventObject.eventLocation,
            let timeStamp = createEventObject.eventTimeStampAPI,
            let participantsCount = createEventObject.participantsCount,
            let cost = createEventObject.cost,
            let description = createEventObject.description
        else { return nil }
        
        let entries = CreateEventEntries(
            name: name,
            location: location,
            timeStamp: timeStamp,
            participantsCount: participantsCount,
            cost: cost,
            currency: createEventObject.currency?.id.description ?? "",
            category: category,
            description: description
        )
        return entries
    }
}
    
    

