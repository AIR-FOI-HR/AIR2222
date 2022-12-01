import UIKit
import NVActivityIndicatorView


class CreateEventViewController: UIViewController {
  
    @IBOutlet private weak var downButtonCategory: UIButton!
    @IBOutlet private weak var downButtonCurrency: UIButton!
    @IBOutlet private weak var categoryTextField: UITextField!
    @IBOutlet private weak var currencyTextField: UITextField!
    @IBOutlet private weak var dateTimePicker: UIDatePicker!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var locationTextField: UITextField!
    @IBOutlet private weak var choseLocationButton: UIButton!
    @IBOutlet private weak var participantsTextField: UITextField!
    @IBOutlet private weak var costTextField: UITextField!
    @IBOutlet private weak var participantsStepper: UIStepper!
    
    private let createEventService = CreateEventService()
    
    var categories = [String]()
    var currencies = [String]()
    var pickerViewCategory = UIPickerView()
    var pickerViewCurrency = UIPickerView()
    var category = ""
    var currency = ""
    var cost = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        participantsTextField.addTarget(self, action: #selector(participantsTextFieldDidChange(_:)), for: .editingChanged)

        categoryTextField.delegate = self
        currencyTextField.delegate = self
        costTextField.delegate = self
        pickerViewCategory.delegate = self
        pickerViewCategory.dataSource = self
        pickerViewCurrency.delegate = self
        pickerViewCurrency.dataSource = self
        
        categoryTextField.layer.shadowOpacity = 0.3
        categoryTextField.layer.shadowRadius = 2.0
        categoryTextField.layer.shadowOffset = CGSizeMake(3, 3)
        categoryTextField.layer.shadowColor = UIColor.gray.cgColor
        categoryTextField.inputView = pickerViewCategory
        categoryTextField.tintColor = UIColor.clear
        
        nameTextField.layer.shadowOpacity = 0.3
        nameTextField.layer.shadowRadius = 2.0
        nameTextField.layer.shadowOffset = CGSizeMake(3, 3)
        nameTextField.layer.shadowColor = UIColor.gray.cgColor
        
        locationTextField.layer.shadowOpacity = 0.3
        locationTextField.layer.shadowRadius = 2.0
        locationTextField.layer.shadowOffset = CGSizeMake(3, 3)
        locationTextField.layer.shadowColor = UIColor.gray.cgColor
        locationTextField.isEnabled = false
        
        dateTimePicker.layer.shadowOpacity = 0.3
        dateTimePicker.layer.shadowRadius = 2.0
        dateTimePicker.layer.shadowOffset = CGSizeMake(3, 3)
        dateTimePicker.layer.shadowColor = UIColor.gray.cgColor
        dateTimePicker.minimumDate = Date()
        
        participantsTextField.layer.shadowOpacity = 0.3
        participantsTextField.layer.shadowRadius = 2.0
        participantsTextField.layer.shadowOffset = CGSizeMake(3, 3)
        participantsTextField.layer.shadowColor = UIColor.gray.cgColor
        
        costTextField.layer.shadowOpacity = 0.3
        costTextField.layer.shadowRadius = 2.0
        costTextField.layer.shadowOffset = CGSizeMake(3, 3)
        costTextField.layer.shadowColor = UIColor.gray.cgColor
        costTextField.text = "0"
        
        currencyTextField.layer.shadowOpacity = 0.3
        currencyTextField.layer.shadowRadius = 2.0
        currencyTextField.layer.shadowOffset = CGSizeMake(3, 3)
        currencyTextField.layer.shadowColor = UIColor.gray.cgColor
        currencyTextField.inputView = pickerViewCurrency
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
    
    @IBAction func chooseLocationButtonPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "PlaceAutocomplete", bundle: nil)
        let placeAutocompleteVC = storyBoard.instantiateViewController(withIdentifier: "PlaceAutocomplete") as! PlaceAutocompleteViewController
        placeAutocompleteVC.delegate = self
        self.present(placeAutocompleteVC, animated: true, completion: nil)
    }
    
    @IBAction func buttonNextPressed(_ sender: Any) {
        guard
            let eventName = nameTextField.text,
            let eventLocation = locationTextField.text,
            let participantsNo = participantsTextField.text,
            let category = categoryTextField.text,
                
            !category.isEmpty && !eventName.isEmpty && !eventLocation.isEmpty && !participantsNo.isEmpty
            else{
                alert(fwdMessage: "Please fill all required information.")
                return
            }

        let storyBoard = UIStoryboard(name: "ShortDescription", bundle: nil)
        let shortDescriptionVC = storyBoard.instantiateViewController(withIdentifier: "ShortDescription") as! ShortDescriptionViewController
        shortDescriptionVC.delegate = self
        shortDescriptionVC.modalPresentationStyle = .fullScreen
        self.present(shortDescriptionVC, animated: true, completion: nil)
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

extension CreateEventViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
extension CreateEventViewController: UITextFieldDelegate {

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

extension CreateEventViewController: PlaceAutocompleteViewContollerDelegate {
    func didSelectPlace(address: String) {
        locationTextField.text = address
    }
}

extension CreateEventViewController: ShortDescriptionViewControllerDelegate {
    func didInputShortDesc(description: String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let eventTimeStamp = dateFormatter.string(from: dateTimePicker.date)
        guard
        let eventName = nameTextField.text,
        let eventLocation = locationTextField.text,
        let participantsNo = participantsTextField.text,
        let cost = costTextField.text
        else{
            return
        }
        let entries = CreateEventEntries(eventName: eventName, eventLocation: eventLocation, eventTimeStamp:eventTimeStamp, participantsNo: participantsNo, cost: cost, currency: currency, category: category, description: description)
        
        createEventService.createEvent(with: entries) {
            (isSuccess) in
            if isSuccess{
                self.alert(fwdMessage: "Successfully created event!")
                self.stopAnimation()
            }else{
                self.alert(fwdMessage: "Wrong input.")
                self.stopAnimation()
            }
        }
    }
}
