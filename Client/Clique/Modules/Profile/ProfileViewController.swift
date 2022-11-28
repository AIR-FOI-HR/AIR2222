//
//  Clique
//  Created by Infinum on 15.11.2022..
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var myEventsButton: UIButton!
    @IBOutlet private var eventsButtons: [UIButton]!
    @IBOutlet private weak var joinedEventsButton: UIButton!
    @IBOutlet private weak var pastJoinedEventsButton: UIButton!
    @IBOutlet private weak var createdEventsButton: UIButton!
    @IBOutlet private weak var pastCreatedEventsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.circleImage()
    }
    
    func showDropDown() {
        eventsButtons.forEach { button in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectMyEvents(_ sender: Any) {
        showDropDown()
    }
    
    @IBAction func joinedEventsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "JoinedEvents" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
    
    @IBAction func pastJoinedEventsButtonPressed( sender: UIButton) {
        let storyboard = UIStoryboard(name: "PastJoinedEvents" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
    
    @IBAction func createdEventsButtonPressed( sender: UIButton) {
        let storyboard = UIStoryboard(name: "CreatedEvents" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
    
    @IBAction func pastCreatedEventsButtonPressed( sender: UIButton) {
        let storyboard = UIStoryboard(name: "PastCreatedEvents" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            present(viewController, animated: true)
        }
    }
}
