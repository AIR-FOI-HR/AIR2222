import UIKit

class CreateEventViewController: UIViewController {
  
    @IBOutlet private weak var downButtonCategory: UIButton!
    @IBOutlet private weak var downButtonCurrency: UIButton!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var currencyTextField: UITextField!
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
        
        categoryTextField.inputView = pickerViewCategory
        currencyTextField.inputView = pickerViewCurrency
        categoryTextField.tintColor = UIColor.clear
        currencyTextField.tintColor = UIColor.clear
        getCategories()
        getCurrencies()
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
