//
//  DateTimeViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//

import Foundation
import UIKit

class DateTimeViewController: UIViewController {
    @IBOutlet private weak var chosenDateTime: UIDatePicker!
    
    var createEventObject = CreateEventObject()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Date and Time (2/5)"
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm"
        let chosenDatePrint = dateFormatterPrint.string(from: chosenDateTime.date)
        
        let dateFormatterAPI = DateFormatter()
        dateFormatterAPI.dateFormat = "yyyy-MM-dd'T'HH:mm:SS'Z'"
        let chosenDateAPI = dateFormatterAPI.string(from: chosenDateTime.date)
        
        
        guard let viewContoller = UIStoryboard(name: "Location", bundle: nil).instantiateInitialViewController() as? LocationViewController else{
            return
        }
        createEventObject.eventTimeStampPrint = chosenDatePrint
        createEventObject.eventTimeStampAPI = chosenDateAPI
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }

}
