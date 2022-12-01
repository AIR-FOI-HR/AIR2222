//
//  EventListViewController.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

import UIKit
import SwiftUI

class EventListViewController : UIViewController{
    
    private var datasource: [Event] = []{
        didSet{_tableView.reloadData()}}
    private var allEvents: [Event] = []
    private var eventServices = EventServices()
    @IBOutlet private var _searchEventsTextField: UITextField!
    @IBOutlet private var _tableView: UITableView!
    @IBOutlet private var _buttonFilter: UIButton!
    
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        _setupUI()
        self._tableView.reloadData()
        _searchEventsTextField.layer.shadowOpacity = 0.3
        _searchEventsTextField.layer.shadowRadius = 2.0
        _searchEventsTextField.layer.shadowOffset = CGSizeMake(3, 3)
        _searchEventsTextField.layer.shadowColor = UIColor.gray.cgColor
        
    }
    
    
}

private extension EventListViewController {
    func _setupUI(){
        getEvents()
        _searchEventsTextField.delegate = self
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.register(UINib(nibName: "EventListTableViewCell", bundle: nil), forCellReuseIdentifier: "EventListTableViewCell")
        
    }
    
    func getEvents(){
        eventServices.getEvent() { result in
            switch result{
            case .success(let events):
                events.forEach{event in
                    self.datasource.append(event)
                }
                self.allEvents = self.datasource
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSearchResults(){
        guard let searchText = _searchEventsTextField.text
        else{
            return
        }
        if(searchText != ""){
            datasource = allEvents.filter{ event in
                return event.eventName.lowercased().contains(searchText.lowercased())
            }
            
        }else{
            datasource = allEvents
        }
        _tableView.reloadData()
    }
    
}
extension EventListViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "EventDetail", bundle: nil)
        let eventDetailViewController =  storyboard.instantiateViewController(withIdentifier: "EventDetail") as? EventDetailViewController
        
        eventDetailViewController?.eventGet = datasource[indexPath.row]
        navigationController?.pushViewController(eventDetailViewController!, animated: true)
    }
    
}

extension EventListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EventListTableViewCell") as! EventListTableViewCell
        cell.configure(with: datasource[indexPath.row])
        cell.contentView.layer.cornerRadius = 7
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor

        return cell
    }
}

extension EventListViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == _searchEventsTextField{
            getSearchResults()
        }
        return true
    }
    
}
