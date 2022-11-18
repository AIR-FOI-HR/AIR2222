//
//  RegisterViewController.swift
//  Clique
//
//  Created by Infinum on 17.11.2022..
//

import Foundation
import UIKit
import SwiftUI

class RegisterViewController: UIViewController {
   
    @IBOutlet private var label: UILabel!
    @IBOutlet private var date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.isHidden = true
        date.backgroundColor = UIColor.orange.withAlphaComponent(0.4)
        date.layer.cornerRadius = 10
        
    }
    
}
