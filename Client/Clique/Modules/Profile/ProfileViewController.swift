//
//  Clique
//  Created by Infinum on 15.11.2022..
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import SkeletonView

class ProfileViewController: UIViewController {
    
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var myEventsButton: UIButton!
    @IBOutlet private var eventsButtons: [UIButton]!
    @IBOutlet private var joinedEventsButton: UIButton!
    @IBOutlet private var pastJoinedEventsButton: UIButton!
    @IBOutlet private var createdEventsButton: UIButton!
    @IBOutlet private var pastCreatedEventsButton: UIButton!
    @IBOutlet private var labelProfileName: UILabel!
    @IBOutlet private var textViewBio: UITextView!
    
    private let profileService = ProfileService()
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        profileImage.circleImage()
//        getUser()
//        profileImage.layer.masksToBounds = false
//        labelProfileName.layer.masksToBounds = false
//        textViewBio.layer.masksToBounds = false
//
//        profileImage.isSkeletonable = true
//        profileImage.showAnimatedSkeleton(usingColor: .clouds,
//                                          transition: .crossDissolve(0.5))
//
//        labelProfileName.isSkeletonable = true
//        labelProfileName.showAnimatedSkeleton(usingColor: .clouds,
//                                              transition: .crossDissolve(0.5))
//
//        textViewBio.isSkeletonable = true
//        textViewBio.showAnimatedSkeleton(usingColor: .clouds,
//                                         transition: .crossDissolve(0.5))
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
    }
    
    private func getUser() {
        profileService.getUser { result in
            switch result {
            case .success(let user):
                    self.profileImage.stopSkeletonAnimation()
                    self.labelProfileName.stopSkeletonAnimation()
                    self.textViewBio.stopSkeletonAnimation()
                    self.view.hideSkeleton(reloadDataAfter: true,
                                           transition: .crossDissolve(0.5))
                    
                    self.labelProfileName.text = user.name + " " + user.surname
                    self.textViewBio.text = user.bio
            case .failure:
                return
            }
        }
    }

    private func showDropdown() {
        eventsButtons.forEach { button in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ProfileEdit" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Settings" , bundle:nil)
        if let viewController = storyboard.instantiateInitialViewController() {
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    @IBAction func selectMyEvents(_ sender: Any) {
        showDropdown()
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
