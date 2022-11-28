//
//  EventListViewController.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

import UIKit
import SwiftUI

class EventListViewController : UIViewController , UIAlertViewDelegate {
    
    private var datasource: [Event] = []{
        didSet{_tableView.reloadData()}}
    private var eventServices = EventServices()
    @IBOutlet private var _tableView: UITableView!
    
    override func viewDidLoad(){
        
        super.viewDidLoad()
        _setupUI()
        self._tableView.reloadData()
    }
}

private extension EventListViewController {
    func _setupUI(){
        getEvents()
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
            case .failure(let error):
                print(error)
            }
        }
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
        cell.contentView.layer.cornerRadius = 70
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.systemOrange.cgColor

        return cell
    }
}
