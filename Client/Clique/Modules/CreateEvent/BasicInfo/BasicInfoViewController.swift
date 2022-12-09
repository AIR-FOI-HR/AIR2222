
import UIKit
import NVActivityIndicatorView


class BasicInfoViewController: UIViewController {
  
    @IBOutlet private weak var downButtonCategory: UIButton!
    @IBOutlet private weak var downButtonCurrency: UIButton!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var participantsTextField: UITextField!
    @IBOutlet private weak var costTextField: UITextField!
    @IBOutlet private weak var costSwitcher: UISwitch!
    @IBOutlet private weak var amountLabel: UILabel!
    
    private let createEventService = CreateEventService()
    var createEventObject = CreateEventObject()
    
    var categories = [String]()
    var currencies = [String]()
    var pickerViewCategory = UIPickerView()
    var pickerViewCurrency = UIPickerView()
    var category = ""
    var currency = ""
    var cost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic info (1/5)"
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
        guard let viewContoller = UIStoryboard(name: "DateTime", bundle: nil).instantiateInitialViewController() as? DateTimeViewController else{
            return
        }
        guard
            let categoryName = categoryTextField.text,
            let eventName = nameTextField.text,
            let participantNumber = participantsTextField.text,
            let cost = costTextField.text,
            let currencyName = currencyTextField.text,
            !categoryName.isEmpty && !eventName.isEmpty && !participantNumber.isEmpty
            
        else{
            alert(fwdMessage: "Please fill all required information.")
            return
        }
        viewContoller.createEventObject.categoryName = categoryName
        viewContoller.createEventObject.categoryId = category
        viewContoller.createEventObject.eventName = eventName
        viewContoller.createEventObject.participantsNumber = participantNumber
        viewContoller.createEventObject.cost = cost
        viewContoller.createEventObject.currencyName = currencyName
        viewContoller.createEventObject.currencyId = currency
        navigationController?.pushViewController(viewContoller, animated: true)
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
    
    @objc func costInputEnabled (switcher: UISwitch) {
        if(switcher.isOn){
            costTextField.isHidden = false
            currencyTextField.isHidden = false
            downButtonCurrency.isHidden = false
            amountLabel.isHidden = false
            currency = "1"
            currencyTextField.text = "EUR"
            costTextField.text = "1"
        }else if(!switcher.isOn){
            costTextField.isHidden = true
            currencyTextField.isHidden = true
            downButtonCurrency.isHidden = true
            amountLabel.isHidden = true
            costTextField.text = "0"
            currency = ""
            currencyTextField.text = ""
        }
    }
    
    func alert(fwdMessage: String) {
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

extension BasicInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == pickerViewCategory) {
            return categories.count
        }
        else{
            return currencies.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == pickerViewCategory) {
            return categories[row]
        }
        else{
            return currencies[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == pickerViewCategory) {
            categoryTextField.text = categories[row]
            category = String((Int(row.description) ?? 0 ) + 1)
        }
        else{
            currencyTextField.text = currencies[row]
            currency = String((Int(row.description) ?? 0 ) + 1)
        }
    }
}
extension BasicInfoViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == costTextField ) {
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

