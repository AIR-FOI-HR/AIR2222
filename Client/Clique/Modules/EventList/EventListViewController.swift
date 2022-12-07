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
    
//    var dateFrom: Date!
//    var priceMin: String!
//    var priceMax: String!
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
//        _buttonFilter.addTarget(self, action: #selector(openFilterView), for: .touchUpInside)
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
    
//    @objc func openFilterView(){
//        let storyboardFilter = UIStoryboard(name: "EventFilter", bundle: nil)
//        guard let eventFilterViewController = storyboardFilter.instantiateViewController(withIdentifier: "EventFilter") as? EventFilterViewController else { return }
//        navigationController?.pushViewController(eventFilterViewController, animated: true)
//        _getFilteredResults()
//    }
//
//    func _getFilteredResults(){
//        guard let pricemax = Double(priceMax), !priceMax.isEmpty else {
//            priceMax = "FREE"
//            return
//        }
//        _events = _storedEvents.filter{
//            $0.eventCost <= pricemax
//        }
//    }
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
