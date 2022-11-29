import UIKit

class CreateEventViewController: UIViewController {
  
    @IBOutlet private weak var downButtonCategory: UIButton!
    @IBOutlet private weak var downButtonCurrency: UIButton!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var dateTimePicker: UIDatePicker!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var participantsTextField: UITextField!
    @IBOutlet private weak var costTextField: UITextField!
    @IBOutlet private weak var shortDescriptionTextField: UITextField!
    @IBOutlet private weak var participantsStepper: UIStepper!
    
    private let createEventService = CreateEventService()
    var categories = [String]()
    var currencies = [String]()
    var pickerViewCategory = UIPickerView()
    var pickerViewCurrency = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.delegate = self
        currencyTextField.delegate = self
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        pickerViewCurrency.delegate = self
        pickerViewCurrency.dataSource = self
        
        categoryTextField.layer.shadowOpacity = 0.3
        categoryTextField.layer.shadowRadius = 2.0
        categoryTextField.layer.shadowOffset = CGSize.zero
        categoryTextField.layer.shadowColor = UIColor.gray.cgColor
        
        nameTextField.layer.shadowOpacity = 0.3
        nameTextField.layer.shadowRadius = 2.0
        nameTextField.layer.shadowOffset = CGSize.zero
        nameTextField.layer.shadowColor = UIColor.gray.cgColor
        
        locationTextField.layer.shadowOpacity = 0.3
        locationTextField.layer.shadowRadius = 2.0
        locationTextField.layer.shadowOffset = CGSize.zero
        locationTextField.layer.shadowColor = UIColor.gray.cgColor
        
        dateTimePicker.layer.shadowOpacity = 0.3
        dateTimePicker.layer.shadowRadius = 2.0
        dateTimePicker.layer.shadowOffset = CGSize.zero
        dateTimePicker.layer.shadowColor = UIColor.gray.cgColor
        
        participantsTextField.layer.shadowOpacity = 0.3
        participantsTextField.layer.shadowRadius = 2.0
        participantsTextField.layer.shadowOffset = CGSize.zero
        participantsTextField.layer.shadowColor = UIColor.gray.cgColor
        
        costTextField.layer.shadowOpacity = 0.3
        costTextField.layer.shadowRadius = 2.0
        costTextField.layer.shadowOffset = CGSize.zero
        costTextField.layer.shadowColor = UIColor.gray.cgColor
        
        currencyTextField.layer.shadowOpacity = 0.3
        currencyTextField.layer.shadowRadius = 2.0
        currencyTextField.layer.shadowOffset = CGSize.zero
        currencyTextField.layer.shadowColor = UIColor.gray.cgColor
        
        shortDescriptionTextField.layer.shadowOpacity = 0.3
        shortDescriptionTextField.layer.shadowRadius = 2.0
        shortDescriptionTextField.layer.shadowOffset = CGSize.zero
        shortDescriptionTextField.layer.shadowColor = UIColor.gray.cgColor
        
        categoryTextField.inputView = pickerViewCategory
        currencyTextField.inputView = pickerViewCurrency
        categoryTextField.tintColor = UIColor.clear
        currencyTextField.tintColor = UIColor.clear
        getCategories()
        getCurrencies()
    }
    
    @IBAction func stpActWeight(_ sender: Any) {
        let number = Int(participantsStepper.value)
            participantsTextField.text = "\(number)"
    }
 
    @IBAction func downButtonCategoryPressed(_ sender: UIButton){
        categoryTextField.becomeFirstResponder()
    }
    @IBAction func downButtonCyrrencyPressed(_ sender: UIButton){
        currencyTextField.becomeFirstResponder()
    }
    
    func getCategories() {
        createEventService.getCategories{ result in
            switch result {
            case .success(let categories):
                for category in categories{
                    self.categories.append(category.category_name)
                }
            case .failure:
                return
            }
        }
    }
    
    func getCurrencies() {
        createEventService.getCurrencies{ result in
            switch result {
            case .success(let currencies):
                for currency in currencies{
                    self.currencies.append(currency.currency_abbr)
                }
            case .failure:
                return
            }
        }
    }
}

extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerViewCategory){
            return categories.count
        }
        else{
            return currencies.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerViewCategory){
            return categories[row]
        }
        else{
            return currencies[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerViewCategory){
            categoryTextField.text = categories[row]
        }
        else{
            currencyTextField.text = currencies[row]
        }
    }
    
}

extension CreateEventViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
