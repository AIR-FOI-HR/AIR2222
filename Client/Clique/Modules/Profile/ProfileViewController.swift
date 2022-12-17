//
//  Clique
//  Created by Infinum on 15.11.2022..
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import SkeletonView

class ProfileViewController: UIViewController {
    
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var myEventsButton: UIButton!
    @IBOutlet private var eventsButtons: [UIButton]!
    @IBOutlet private var joinedEventsButton: UIButton!
    @IBOutlet private var pastJoinedEventsButton: UIButton!
    @IBOutlet private var createdEventsButton: UIButton!
    @IBOutlet private var pastCreatedEventsButton: UIButton!
    @IBOutlet private var labelProfileName: UILabel!
    @IBOutlet private var bioTextView: UITextView!
    
    private let profileService = ProfileService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.rounded()
        getUser()
        
        profileImage.skeletonableView()
        labelProfileName.skeletonableView()
        bioTextView.skeletonableView()
        myEventsButton.skeletonableView()
        
        labelProfileName.skeletonTextNumberOfLines = 1
        labelProfileName.skeletonTextLineHeight = .relativeToFont
        labelProfileName.skeletonPaddingInsets = UIEdgeInsets(top: 0,
                                                              left: 70,
                                                              bottom: 0,
                                                              right: 0)
        
        bioTextView.layer.borderColor = UIColor.systemGray6.cgColor
        bioTextView.layer.borderWidth = 1
//        createdEventsButton.addTarget(self, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
    }
    
    private func getUser() {
        profileService.getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.profileImage.stopSkeletonAnimation()
                self?.labelProfileName.stopSkeletonAnimation()
                self?.bioTextView.stopSkeletonAnimation()
                self?.myEventsButton.stopSkeletonAnimation()
                self?.view.hideSkeleton(reloadDataAfter: true,
                                       transition: .crossDissolve(0.5))
                self?.labelProfileName.text = user.name + " " + user.surname
                self?.bioTextView.text = user.bio
            case .failure:
                return
            }
        }
    }
    
    @IBAction private func editButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "ProfileEdit", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func selectMyEvents(_ sender: Any) {
        eventsButtons.forEach { button in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func joinedEventsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "JoinedEvents", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pastJoinedEventsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "PastJoinedEvents", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func createdEventsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "CreatedEvents", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pastCreatedEventsButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewController = UIStoryboard(name: "PastCreatedEvents", bundle: nil).instantiateInitialViewController() else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
