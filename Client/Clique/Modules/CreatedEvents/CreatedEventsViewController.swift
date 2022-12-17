//
//  CreatedEventsViewController.swift
//  Clique
//
//  Created by Infinum on 27.11.2022..
//

import UIKit

class CreatedEventsViewController: UIViewController {
    
    @IBOutlet private var _tableView : UITableView?
    
    private var _events : [Event] = [] {
        didSet {
            _tableView?.reloadData()
        }
    }
    private var _eventServices = EventServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        _getEvents()
    }
}

private extension CreatedEventsViewController {
    func setupUI(){
        _tableView?.delegate = self
        _tableView?.dataSource = self
        _tableView!.register(UINib(nibName: Constants.Storyboards.eventListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Storyboards.eventListTableViewCell)
    }
    
    func _getEvents(){
        _eventServices.getLogUserEvents() { [weak self] result in
            guard let _viewController = self else { return }
            switch result{
            case .success(let events):
                _viewController._events = events
            case .failure(let error):
                print(error)
                
            }
        }
    }
}

extension CreatedEventsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.eventDetail, bundle: nil)
        let eventDetailViewController = storyboard.instantiateViewController(withIdentifier: Constants.Storyboards.eventDetail) as? EventDetailViewController
        
        eventDetailViewController?.event = _events[indexPath.row]
        navigationController?.pushViewController(eventDetailViewController!, animated: true)
    }
}

extension CreatedEventsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let _cell: EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboards.eventListTableViewCell) as? EventListTableViewCell
        else {
            let _cell = UITableViewCell()
            return _cell
        }
        _cell.configure(with: _events[indexPath.row])
        _cell.contentView.layer.cornerRadius = 7
        _cell.contentView.layer.borderWidth = 0.5
        _cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        return _cell
    }
}
