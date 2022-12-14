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
    
    let dateFormatter = DateFormatter()
    private var _events: [Event] = [] {
        didSet { _tableView.reloadData() }
    }
    private var _storedEvents: [Event] = []
    private var _eventServices = EventServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
        _getEvents()
        
    }
}
private extension EventListViewController {
    
    func _setupUI() {
        
        _buttonFilter.addTarget(self, action: #selector(_openFilterView), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(_clearFilters))
         tapGesture.numberOfTapsRequired = 2
        _buttonFilter.addGestureRecognizer(tapGesture)
        _searchEventsTextField.delegate = self
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(UINib(nibName: Constants.Storyboards.eventListTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Storyboards.eventListTableViewCell)
        _searchEventsTextField.layer.shadowOpacity = 0.3
        _searchEventsTextField.layer.shadowRadius = 2.0
        _searchEventsTextField.layer.shadowOffset = CGSizeMake(3, 3)
        _searchEventsTextField.layer.shadowColor = UIColor.gray.cgColor
        dateFormatter.dateFormat = "dd/MM/yyy HH:mm:ss"
    }
    
    func _getEvents() {
        
        _eventServices.getEvent() { [weak self] result in
            guard let _self = self else { return }
            switch result{
            case .success(let events):
                _self._events = events
                _self._storedEvents = _self._events
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func _getSearchResults() {
        
        guard
            let searchText = _searchEventsTextField.text,
            !searchText.isEmpty
        else {
            _events = _storedEvents
            return
        }
        
        _events = _storedEvents.filter { $0.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    @objc func _openFilterView() {
        
        let storyboardEventFilter = UIStoryboard(name: "EventFilter", bundle: nil)
        let eventFilterViewController =  storyboardEventFilter.instantiateViewController(withIdentifier: "EventFilter") as? EventFilterViewController
        eventFilterViewController?.delegate = self
        navigationController?.pushViewController(eventFilterViewController!, animated: true)
    }
    
    @objc func _clearFilters() {
        _events = _storedEvents
    }
}

extension EventListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: Constants.Storyboards.eventDetail, bundle: nil)
        let eventDetailViewController =  storyboard.instantiateViewController(withIdentifier: Constants.Storyboards.eventDetail) as? EventDetailViewController
        eventDetailViewController?.event = _events[indexPath.row]
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
        cell.configure(with: _events[indexPath.row])
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }
}

extension EventListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == _searchEventsTextField{
            _getSearchResults()
        }
        return true
    }
}

extension EventListViewController: EventFilterDelegate {
    
    func getFilteredEvents(filter: Filter) {
        self.navigationController?.popViewController(animated: true)
        _events  = _storedEvents.filter {
            return $0.cost ?? 0 <= filter.priceMax
            && $0.cost ?? 0 >= filter.priceMin
            && dateFormatter.date(from: $0.timestamp) ?? Date() >= filter.dateFrom
        }
    }
}
