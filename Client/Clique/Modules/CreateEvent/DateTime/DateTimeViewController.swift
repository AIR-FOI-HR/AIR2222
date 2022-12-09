//
//  DateTimeViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//
import UIKit

class DateTimeViewController: UIViewController {
    
    @IBOutlet private var chosenDateTime: UIDatePicker!
    
    var createEventObject = CreateEventObject()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenDateTime.minimumDate = Date()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Constants.DateFormats.dateFormatterPrint
        let chosenDatePrint = dateFormatterPrint.string(from: chosenDateTime.date)

        let dateFormatterAPI = DateFormatter()
        dateFormatterAPI.dateFormat = Constants.DateFormats.dateFormatterAPI
        let chosenDateAPI = dateFormatterAPI.string(from: chosenDateTime.date)
        
        guard let viewContoller = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController
        else { return }
        createEventObject.eventTimeStampPrint = chosenDatePrint
        createEventObject.eventTimeStampAPI = chosenDateAPI
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }
}
