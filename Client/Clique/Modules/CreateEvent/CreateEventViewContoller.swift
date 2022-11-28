import UIKit

class CreateEventViewController: UIViewController {
  
    @IBOutlet private weak var downButton: UIButton!
    @IBOutlet private weak var categoryTextField: UITextField!
    private let createEventService = CreateEventService()
    var categories = [String]()
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        categoryTextField.tintColor = UIColor.clear
        getCategories()
    }
 
    @IBAction func downButtonPressed(_ sender: UIButton){
        categoryTextField.becomeFirstResponder()
    }
    
    func getCategories() {
        createEventService.getCategories{ result in
            switch result {
            case .success(let cats):
                for cat in cats{
                    self.categories.append(cat.category_name)
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
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = categories[row]
    }
    
}

extension CreateEventViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
}
