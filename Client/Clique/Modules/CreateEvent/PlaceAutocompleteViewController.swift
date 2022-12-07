//
//import GooglePlaces
//import UIKit
//
//protocol PlaceAutocompleteViewContollerDelegate {
//    func didSelectPlace(address: String)
//}
//
//class PlaceAutocompleteViewController: UIViewController {
//
//    private var tableView: UITableView!
//    private var tableDataSource: GMSAutocompleteTableDataSource!
//    var delegate: PlaceAutocompleteViewContollerDelegate!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 25, width: self.view.frame.size.width, height: 44.0))
//        searchBar.delegate = self
//        view.addSubview(searchBar)
//        tableDataSource = GMSAutocompleteTableDataSource()
//        tableDataSource.delegate = self
//        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height - 44))
//        tableView.delegate = tableDataSource
//        tableView.dataSource = tableDataSource
//        view.addSubview(tableView)
//  }
//}
//
//extension PlaceAutocompleteViewController: UISearchBarDelegate {
//  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    tableDataSource.sourceTextHasChanged(searchText)
//  }
//}
//
//extension PlaceAutocompleteViewController: GMSAutocompleteTableDataSourceDelegate {
//  func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
//      tableView.reloadData()
//  }
//
//  func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
//      tableView.reloadData()
//  }
//
//  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
//      delegate.didSelectPlace(address: place.formattedAddress!)
//  }
//
//  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
//      return
//  }
//
//  func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//      dismiss(animated: true)
//      return true
//  }
//}
//
//
//
//
