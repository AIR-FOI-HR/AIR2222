//
//  EventDetailViewController.swift
//  Clique
//
//  Created by Infinum on 18.11.2022..
//

import Foundation
import UIKit

class EventDetailViewController: UIViewController{
    var eventGet : Event!
    
    @IBOutlet private var _eventPreparation: UILabel!
    @IBOutlet private var _eventName: UILabel!
    @IBOutlet private var _eventImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
}

private extension EventDetailViewController {
    
    func _setupUI(){
        
        guard let _event = eventGet else {return}
        title = _event.eventName
        _eventName.text = _event.eventName
        
        
    }
}
