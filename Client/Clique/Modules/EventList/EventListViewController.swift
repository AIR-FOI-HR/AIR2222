//
//  EventListViewController.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation
import UIKit

class EventListViewController: UIViewController {
    
    @IBOutlet private var _searchEventsTextField: UITextField!
    @IBOutlet private var _tableView: UITableView!
    @IBOutlet private var _buttonFilter: UIButton!
    
    private var events: [Event] = [] {
        didSet { _tableView.reloadData() }
        
    }
    private var storedEvents: [Event] = []
    private var eventServices = EventServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        _getEvents()
        
    }
}

private extension EventListViewController {
    
    func _setupUI() {
        _searchEventsTextField.delegate = self
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(UINib(nibName: Constants.Storyboards.eventListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Storyboards.eventListTableViewCell)
        _searchEventsTextField.layer.shadowOpacity = 0.3
        _searchEventsTextField.layer.shadowRadius = 2.0
        _searchEventsTextField.layer.shadowOffset = CGSizeMake(3, 3)
        _searchEventsTextField.layer.shadowColor = UIColor.gray.cgColor
        
    }
    
    func _getEvents(){
        eventServices.getEvent() { [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let events):
                _self.events = events
                _self.storedEvents = _self.events
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func getSearchResults() {
        guard
            let searchText = _searchEventsTextField.text,
            !searchText.isEmpty
        else {
            events = storedEvents
            return
        }
        
        events = storedEvents.filter { $0.eventName.lowercased().contains(searchText.lowercased())
        }
    }
}
extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.eventDetail, bundle: nil)
        let eventDetailViewController =  storyboard.instantiateViewController(withIdentifier: Constants.Storyboards.eventDetail) as? EventDetailViewController
        
        eventDetailViewController?.eventGet = events[indexPath.row]
        navigationController?.pushViewController(eventDetailViewController!, animated: true)
    }
}

extension EventListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.Storyboards.eventListTableViewCell) as? EventListTableViewCell
        else {
            let cell = UITableViewCell()
            return cell
        }
        cell.configure(with: events[indexPath.row])
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }
}

extension EventListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == _searchEventsTextField{
            getSearchResults()
        }
        return true
    }
}
