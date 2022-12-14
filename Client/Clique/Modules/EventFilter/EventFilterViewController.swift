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
    
    @IBOutlet private var _labelDate: UILabel!
    @IBOutlet private var _labelPriceMin: UILabel!
    @IBOutlet private var _labelPriceMax: UILabel!
    @IBOutlet private var _datePicker: UIDatePicker!
    @IBOutlet private var _textFieldPriceMin: UITextField!
    @IBOutlet private var _textFieldPriceMax: UITextField!
    @IBOutlet private var _buttonFilter: UIButton!
    
    var filter = Filter(priceMin: 0, priceMax: 9999, dateFrom: Date())
    var delegate: EventFilterDelegate?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
        _buttonFilter.addTarget(self, action: #selector(closeAndGet), for: .touchUpInside)
    }
}

extension EventFilterViewController {
    
    func setupUI() {
        _labelDate.text = "Date from:"
        _labelPriceMin.text = "Price min:"
        _labelPriceMax.text = "Price max:"
    }
    
    @objc func closeAndGet() {
        if let doubleValue = Double(_textFieldPriceMax.text!) {
            filter.priceMax = doubleValue
        }
        if let doubleValue = Double(_textFieldPriceMin.text!) {
            filter.priceMin = doubleValue
        }
        filter.dateFrom = _datePicker.date
        delegate?.getFilteredEvents(filter: filter)
    }
}


