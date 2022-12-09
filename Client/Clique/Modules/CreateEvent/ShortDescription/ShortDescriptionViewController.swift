//
//  ShortDescriptionViewController.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import UIKit
import NVActivityIndicatorView

class ShortDescriptionViewController: UIViewController {
    
    @IBOutlet private var shortDescriptionTextView: UITextView!
    var createEventObject = CreateEventObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shortDescriptionTextView.layer.cornerRadius = 7
        shortDescriptionTextView.layer.masksToBounds = false
        shortDescriptionTextView.delegate = self
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "CreateEventOverview", bundle: nil).instantiateInitialViewController() as? CreateEventOverviewViewController
        else { return }
        guard
            let shortDescription = shortDescriptionTextView.text,
            !shortDescription.isEmpty
        else {
            Functions.Alerts.alert(fwdMessage: Constants.Alerts.pleaseEnterShortDescriptionMsg, viewController: self)
            return
        }
        createEventObject.description = shortDescription
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
}
extension ShortDescriptionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 250
    }
}







