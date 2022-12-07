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
    
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var participantNumberLabel: UILabel!
    @IBOutlet private weak var eventCostLabel: UILabel!
    @IBOutlet private weak var chosenDateTimeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var postButton: UIButton!
    
    var selectedCategory: String = ""
    var eventName: String = ""
    var participantNumber: String = ""
    var eventCost: String = ""
    var chosenDateTime: String = ""
    var location: String = ""
    var shortDescription: String = ""
    var currency: String = ""
    
    private let createEventService = CreateEventService()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Overview"
        categoryLabel.text = selectedCategory
        eventNameLabel.text = eventName
        participantNumberLabel.text = participantNumber
        eventCostLabel.text = eventCost
        chosenDateTimeLabel.text = chosenDateTime
        locationLabel.text = location
        shortDescriptionLabel.text = shortDescription
        currencyLabel.text = currency
        
    }
    
    @IBAction func postButtonPressed(_sender: UIButton){
        guard let createEntries = getCreateEventEntries() else {
            return
        }
        print(createEntries)
        startAnimation()
        createEvent(with: createEntries)
        
    }
    
    func createEvent(with createEventEntries: CreateEventEntries) {
        createEventService.createEvent(with: createEventEntries) {
            (isSuccess) in
            if isSuccess{
                self.alert(fwdMessage: "Successfully created event!")
                self.stopAnimation()
            }else{
                self.alert(fwdMessage: "Wrong input.")
                self.stopAnimation()
            }
        }
    }
    
    func getCreateEventEntries() -> CreateEventEntries? {
    
        guard
            let eventName = eventNameLabel.text,
            let eventLocation = locationLabel.text,
            let eventTimeStamp = chosenDateTimeLabel.text,
            let participantsNo = participantNumberLabel.text,
            let cost = eventCostLabel.text,
            let currency = currencyLabel.text,
            let category = categoryLabel.text,
            let description = shortDescriptionLabel.text
        else {
            return nil
        }
        let entries = CreateEventEntries(eventName: eventName, eventLocation: eventLocation, eventTimeStamp: "2022-11-03T12:22:11Z", participantsNo: participantsNo, cost: "2", currency: "1", category: "1", description: description)
        return entries

    }
    
    func alert(fwdMessage: String){
        let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
    private func startAnimation() {
            loading.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loading)
            NSLayoutConstraint.activate([
                loading.widthAnchor.constraint(equalToConstant: 40),
                loading.heightAnchor.constraint(equalToConstant: 40),
                loading.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 350),
                loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            loading.startAnimating()
        }
    private func stopAnimation() {
            loading.stopAnimating()
        }
    
}
    
    

