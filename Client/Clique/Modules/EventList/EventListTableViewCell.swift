//
//  EventListTableViewCell.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation
import UIKit
import Alamofire

class EventListTableViewCell : UITableViewCell{
    @IBOutlet private var _nameLabel: UILabel!
    @IBOutlet private var _eventImage: UIImageView!
    @IBOutlet private var _eventLocation: UILabel!
    @IBOutlet private var _eventDateTime: UILabel!
    @IBOutlet private var _likeButton: UIButton!
     
    func configure(with event: Event){
        _nameLabel.text = event.eventName
        layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        _nameLabel.layer.shadowOpacity = 0.3
        _nameLabel.layer.shadowRadius = 2.0
        _nameLabel.layer.shadowOffset = CGSizeMake(3, 3)
        _nameLabel.layer.shadowColor = UIColor.gray.cgColor
    }
    /**func setupImage(with url: String){
        AF.request(url).responseImage{[weak self] response in
            if
                case.success(let image) = response.result {self?._eventImage.image = image
                
            }
            
        }
    }**/
}
