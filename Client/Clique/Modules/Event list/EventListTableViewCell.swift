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
     
    func configure(with event: Event){
        _nameLabel.text = event.eventName
        layoutSubviews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    /**func setupImage(with url: String){
        AF.request(url).responseImage{[weak self] response in
            if
                case.success(let image) = response.result {self?._eventImage.image = image
                
            }
            
        }
    }**/
}
