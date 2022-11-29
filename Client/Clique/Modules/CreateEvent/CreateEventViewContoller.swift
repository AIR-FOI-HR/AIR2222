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
    @IBOutlet private weak var shortDescriptionTextView: UITextView!
    @IBOutlet private weak var participantsStepper: UIStepper!
    
    private let createEventService = CreateEventService()
    var categories = [String]()
    var currencies = [String]()
    var pickerViewCategory = UIPickerView()
    var pickerViewCurrency = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        participantsTextField.addTarget(self, action: #selector(participantsTextFieldDidChange(_:)), for: .editingChanged)
        
        categoryTextField.delegate = self
        currencyTextField.delegate = self
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        pickerViewCurrency.delegate = self
        pickerViewCurrency.dataSource = self
        
        categoryTextField.layer.shadowOpacity = 0.3
        categoryTextField.layer.shadowRadius = 2.0
        categoryTextField.layer.shadowOffset = CGSizeMake(3, 3)
        categoryTextField.layer.shadowColor = UIColor.gray.cgColor
        
        nameTextField.layer.shadowOpacity = 0.3
        nameTextField.layer.shadowRadius = 2.0
        nameTextField.layer.shadowOffset = CGSizeMake(3, 3)
        nameTextField.layer.shadowColor = UIColor.gray.cgColor
        
        locationTextField.layer.shadowOpacity = 0.3
        locationTextField.layer.shadowRadius = 2.0
        locationTextField.layer.shadowOffset = CGSizeMake(3, 3)
        locationTextField.layer.shadowColor = UIColor.gray.cgColor
        
        dateTimePicker.layer.shadowOpacity = 0.3
        dateTimePicker.layer.shadowRadius = 2.0
        dateTimePicker.layer.shadowOffset = CGSizeMake(3, 3)
        dateTimePicker.layer.shadowColor = UIColor.gray.cgColor
        
        participantsTextField.layer.shadowOpacity = 0.3
        participantsTextField.layer.shadowRadius = 2.0
        participantsTextField.layer.shadowOffset = CGSizeMake(3, 3)
        participantsTextField.layer.shadowColor = UIColor.gray.cgColor
        
        costTextField.layer.shadowOpacity = 0.3
        costTextField.layer.shadowRadius = 2.0
        costTextField.layer.shadowOffset = CGSizeMake(3, 3)
        costTextField.layer.shadowColor = UIColor.gray.cgColor
        
        currencyTextField.layer.shadowOpacity = 0.3
        currencyTextField.layer.shadowRadius = 2.0
        currencyTextField.layer.shadowOffset = CGSizeMake(3, 3)
        currencyTextField.layer.shadowColor = UIColor.gray.cgColor
        
//        shortDescriptionTextView.layer.shadowOpacity = 0.3
//        shortDescriptionTextView.layer.shadowRadius = 2.0
//        shortDescriptionTextView.layer.shadowOffset = CGSizeMake(3, 3)
//        shortDescriptionTextView.layer.shadowColor = UIColor.gray.cgColor
//        shortDescriptionTextView.layer.cornerRadius = 7
//        shortDescriptionTextView.layer.masksToBounds = false
        
        categoryTextField.inputView = pickerViewCategory
        currencyTextField.inputView = pickerViewCurrency
        categoryTextField.tintColor = UIColor.clear
        currencyTextField.tintColor = UIColor.clear
        getCategories()
        getCurrencies()
    }
    
    @objc func participantsTextFieldDidChange(_ textField: UITextField) {
        self.participantsStepper.value = Double(textField.text!) ?? 0.0
    }
    
    @IBAction func stteperChange(_ sender: Any) {
            participantsTextField.text = "\(Int(participantsStepper.value))"
    }
 
    @IBAction func downButtonCategoryPressed(_ sender: UIButton) {
        categoryTextField.becomeFirstResponder()
    }
    @IBAction func downButtonCyrrencyPressed(_ sender: UIButton) {
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
