//
//  EventListTableViewCell.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation
import UIKit
import Alamofire

class EventListTableViewCell: UITableViewCell {
    
    @IBOutlet private var _eventName: UILabel!
    @IBOutlet private var _eventImage: UIImageView!
    @IBOutlet private var _eventLocation: UILabel!
    @IBOutlet private var _eventTimestamp: UILabel!
    @IBOutlet private var _likeButton: UIButton!
     
    func configure(with event: Event) {
        _eventName.text = event.name
        _eventLocation.text = event.location
        _eventTimestamp.text = event.timestamp
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        _eventName.layer.shadowOpacity = 0.3
        _eventName.layer.shadowRadius = 2.0
        _eventName.layer.shadowOffset = CGSizeMake(3, 3)
        _eventName.layer.shadowColor = UIColor.gray.cgColor
    }  
}
