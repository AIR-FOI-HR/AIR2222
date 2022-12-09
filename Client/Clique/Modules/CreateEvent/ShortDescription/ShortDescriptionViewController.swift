//
//  ShortDescriptionViewController.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//
import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class ShortDescriptionViewController: UIViewController {
    
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    @IBOutlet private var shortDescriptionTextView: UITextView!
    @IBOutlet private var characterCountLabel: UILabel!
    var createEventObject = CreateEventObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
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
        var countdown = 251 - updatedText.count
        let text = "Write a short description of your event! U have" + " \(countdown) " + "characters remaining."
        let range = (text as NSString).range(of: "\(countdown)")
        let attributedString = NSMutableAttributedString(string:text)
        if countdown == 0 {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: range)
        } else if countdown > 0 && countdown < 11 {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemYellow , range: range)
        } else {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen , range: range)
        }
        characterCountLabel.attributedText = attributedString
        return updatedText.count <= 250
        
    }
}







