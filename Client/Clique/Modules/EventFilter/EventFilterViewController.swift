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
    
    private var _pickerViewCategory = UIPickerView()
    var categoryList: [Category] = []
    private var _categoryService = CategoryServices()
    var filter = Filter(dateFrom: Date(), dateTo: Date(), numOfPart: 0, state: Filter.Cost.trueTrue, category: " ")
    var delegate: EventFilterDelegate?
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let sliderValue = Int(_radiusSlider.value)
        _radiusLabel.text = String("\(sliderValue) km")
    }
    
    @IBAction func applyFilter(_ sender: UIBarButtonItem) {
        filter.dateFrom = _fromDatePicker.date
        filter.dateTo = _toDatePicker.date
        if _freeSwitch.isOn == true && _paymentSwitch.isOn == true {
            filter.state = Filter.Cost.trueTrue
        } else if _freeSwitch.isOn == true && _paymentSwitch.isOn == false {
            filter.state = Filter.Cost.trueFalse
        } else if _freeSwitch.isOn == false && _paymentSwitch.isOn == true {
            filter.state = Filter.Cost.falseTrue
        }
        filter.numOfPart = Int( _participantsTextField.text ?? "50") ?? 50
        if _categoryTextField.state.isEmpty {
            filter.category = " "
        } else {
            guard let categoryText = _categoryTextField.text else { return }
            filter.category = categoryText
        }
        delegate?.getFilteredEvents(filter: filter)
    }
    
    @IBAction func _categoryDropDownPressed(_ sender: UIButton) {
        _categoryTextField.becomeFirstResponder()
    }
}

extension EventFilterViewController {
    
    func setupUI() {
        _freeSwitch.isOn = true
        _paymentSwitch.isOn = true
        _participantsTextField.placeholder = "50"
        _getCategories()
        _pickerViewCategory.delegate = self
        _pickerViewCategory.dataSource = self
        _categoryTextField.text = " "
        _categoryTextField.inputView = _pickerViewCategory
    }
    
    func _getCategories() {
        
        _categoryService.getCategory() { [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let categories):
                _self.categoryList = categories
            case .failure(let error):
                print(error)
                
            }
        }
    }
}


extension EventFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ _pickerViewCategory: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ _pickerViewCategory: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row].name
    }
    
    func pickerView(_ _pickerViewCategory: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _categoryTextField.text = categoryList[row].name
    }
}
