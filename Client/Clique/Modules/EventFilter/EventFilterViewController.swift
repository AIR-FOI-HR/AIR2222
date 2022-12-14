//
//  EventFilter.swift
//  Clique
//
//  Created by Infinum on 06.12.2022..
//

import Foundation
import UIKit

protocol EventFilterDelegate {
    func getFilteredEvents(filter: Filter)
}

class EventFilterViewController: UIViewController {
    
    @IBOutlet private var _categoryTextField: UITextField!
    @IBOutlet private var _categoryDropDown: UIButton!
    @IBOutlet private var _locationTextField: UITextField!
    @IBOutlet private var _locationPick: UIButton!
    @IBOutlet private var _radiusSlider: UISlider!
    @IBOutlet private var _radiusLabel: UILabel!
    @IBOutlet private var _fromDatePicker: UIDatePicker!
    @IBOutlet private var _toDatePicker: UIDatePicker!
    @IBOutlet private var _freeSwitch: UISwitch!
    @IBOutlet private var _paymentSwitch: UISwitch!
    @IBOutlet private var _participantsTextField: UITextField!
    @IBOutlet private var _applyButton: UIBarButtonItem!
    
    var filter = Filter(dateFrom: Date())
//    var filter = Filter(priceMin: 0, priceMax: 9999, dateFrom: Date())
    var delegate: EventFilterDelegate?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        setupUI()
//        _buttonFilter.addTarget(self, action: #selector(closeAndGet), for: .touchUpInside)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let sliderValue = Int(_radiusSlider.value)
        _radiusLabel.text = String("\(sliderValue) km")
    }
    
    @IBAction func applyFilter(_ sender: UIBarButtonItem) {
        filter.dateFrom = _fromDatePicker.date
        delegate?.getFilteredEvents(filter: filter)
    }
}

extension EventFilterViewController {
    
//    func setupUI() {
//        _labelDate.text = "Date from:"
//        _labelPriceMin.text = "Price min:"
//        _labelPriceMax.text = "Price max:"
//    }
    
//    @objc func closeAndGet() {
//        if let doubleValue = Double(_textFieldPriceMax.text!) {
//            filter.priceMax = doubleValue
//        }
//        if let doubleValue = Double(_textFieldPriceMin.text!) {
//            filter.priceMin = doubleValue
//        }
//        filter.dateFrom = _datePicker.date
//        delegate?.getFilteredEvents(filter: filter)
//    }
}




