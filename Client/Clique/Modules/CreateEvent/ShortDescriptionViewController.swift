//
//  ShortDescriptionViewController.swift
//  Clique
//
//  Created by Infinum on 29.11.2022..
//

import UIKit
import NVActivityIndicatorView

protocol ShortDescriptionViewControllerDelegate {
    func didInputShortDesc(description: String)
}

class ShortDescriptionViewController: UIViewController {
    
    @IBOutlet private weak var shortDescriptionTextView: UITextView!
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var dismissButton: UIButton!

    var delegate : ShortDescriptionViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        shortDescriptionTextView.layer.shadowOpacity = 0.3
        shortDescriptionTextView.layer.shadowRadius = 2.0
        shortDescriptionTextView.layer.shadowOffset = CGSizeMake(3, 3)
        shortDescriptionTextView.layer.shadowColor = UIColor.gray.cgColor
        shortDescriptionTextView.layer.cornerRadius = 7
        shortDescriptionTextView.layer.masksToBounds = false
        shortDescriptionTextView.delegate = self
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        startAnimation()
        guard
            let description = shortDescriptionTextView.text,
            !description.isEmpty
        else {
            alert(fwdMessage: "Please fill out short description.")
            return
            }
        delegate.didInputShortDesc(description: description)
        stopAnimation()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        dismiss(animated: true,completion: nil)
    }
          
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballBeat, color: .orange, padding: 0)
    func startAnimation() {
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
    
    func stopAnimation() {
        loading.stopAnimating()
    }
    
    func alert(fwdMessage: String) {
        let alertController = UIAlertController(title: "", message: fwdMessage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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







