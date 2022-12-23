
import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class BasicInfoViewController: UIViewController {
  
    @IBOutlet private var downButtonCategory: UIButton!
    @IBOutlet private var downButtonCurrency: UIButton!
    @IBOutlet private var categoryTextField: UITextField!
    @IBOutlet private var currencyTextField: UITextField!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var participantsTextField: UITextField!
    @IBOutlet private var costTextField: UITextField!
    @IBOutlet private var costSwitcher: UISwitch!
    @IBOutlet private var amountLabel: UILabel!
    
    private let createEventService = CreateEventService()
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    var createEventObject = CreateEventObject()
    
    var selectedCategory : Category?
    var selectedCurrency : Currency?
    var categories = [Category]()
    var currencies = [Currency]()
    var pickerViewCategory = UIPickerView()
    var pickerViewCurrency = UIPickerView()
    var cost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        onLoadSettings()
        getCategories()
        getCurrencies()
    }

    @IBAction func downButtonCategoryPressed(_ sender: UIButton) {
        categoryTextField.becomeFirstResponder()
    }
    
    @IBAction func downButtonCyrrencyPressed(_ sender: UIButton) {
        currencyTextField.becomeFirstResponder()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "DateTime", bundle: nil).instantiateInitialViewController() as? DateTimeViewController
        else { return }
        guard
            let categoryName = categoryTextField.text,
            let eventName = nameTextField.text,
            let participantsCount = participantsTextField.text,
            let cost = costTextField.text,
            !categoryName.isEmpty && !eventName.isEmpty && !participantsCount.isEmpty
        else {
            showAlert(message: Constants.Alerts.pleaseEnterInfoMessage)
            return
        }
        viewContoller.createEventObject.category = selectedCategory
        viewContoller.createEventObject.eventName = eventName
        viewContoller.createEventObject.participantsCount = participantsCount
        viewContoller.createEventObject.cost = cost
        viewContoller.createEventObject.currency = selectedCurrency
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    func getCategories() {
        createEventService.getCategories{ [weak self] result in
            switch result {
            case .success(let categories):
                for category in categories{
                    self?.categories.append(category)
                }
            case .failure:
                return
            }
        }
    }
    
    func getCurrencies() {
        createEventService.getCurrencies { [weak self] result in
            switch result {
            case .success(let currencies):
                for currency in currencies {
                    self?.currencies.append(currency)
                }
            case .failure:
                return
            }
        }
    }
    
    @objc func costInputEnabled (switcher: UISwitch) {
        if switcher.isOn {
            selectedCurrency = Currency(id: 1, name: "EURO", abbreviation: "EUR")
            costTextField.isHidden = false
            currencyTextField.isHidden = false
            downButtonCurrency.isHidden = false
            amountLabel.isHidden = false
            currencyTextField.text = "EUR"
            costTextField.text = "1"
        } else if !switcher.isOn {
            costTextField.isHidden = true
            currencyTextField.isHidden = true
            downButtonCurrency.isHidden = true
            amountLabel.isHidden = true
            costTextField.text = "0"
            selectedCurrency = nil
            currencyTextField.text = ""
        }
    }
    
    func onLoadSettings() {
        costSwitcher.addTarget(self, action: #selector(costInputEnabled(switcher:)), for: .valueChanged)
        categoryTextField.delegate = self
        currencyTextField.delegate = self
        costTextField.delegate = self
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        pickerViewCurrency.delegate = self
        pickerViewCurrency.dataSource = self
        categoryTextField.inputView = pickerViewCategory
        categoryTextField.tintColor = UIColor.clear
        currencyTextField.inputView = pickerViewCurrency
        currencyTextField.tintColor = UIColor.clear
        costTextField.isHidden = true
        currencyTextField.isHidden = true
        downButtonCurrency.isHidden = true
        amountLabel.isHidden = true
        costTextField.text = "0"
    }
}

extension BasicInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewCategory {
            return categories.count
        }
        else {
            return currencies.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerViewCategory {
            return categories[row].name
        }
        else {
            return currencies[row].abbreviation
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewCategory {
            categoryTextField.text = categories[row].name
            selectedCategory = categories[row]
        }
        else {
            currencyTextField.text = currencies[row].abbreviation
            selectedCurrency = currencies[row]
        }
    }
}
extension BasicInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == costTextField {
            guard let costCheck = costTextField.text, let range = Range(range, in: costCheck) else {
                return false
            }
            let costField = costCheck.replacingCharacters(in: range, with: string)
            if costField.isEmpty {
                costTextField.text = "0"
                return false
            } else if costTextField.text == "0" {
                costTextField.text = string
                return false
            }
            return true
        }
        else {
            return false
        }
    }
}

