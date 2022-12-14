//
//  LocationViewController.swift
//  Clique
//
//  Created by Infinum on 07.12.2022..
//
import UIKit
import MapKit
import GooglePlaces
import IQKeyboardManagerSwift
import CoreLocation

class LocationViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate {
    
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var chosenLocationTextField: UITextField!
    @IBOutlet private var searchButton: UIButton!
    @IBOutlet private var chooseMyLocationButton: UIButton!
    var returnKeyHandler = IQKeyboardReturnKeyHandler()
    var createEventObject = CreateEventObject()
    private let createEventService = CreateEventService()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    let locationManager = CLLocationManager()
    var completion: ((CLLocation) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnKeyHandler = IQKeyboardReturnKeyHandler(controller: self)
        chosenLocationTextField.tintColor = UIColor.clear
        chosenLocationTextField.delegate = self
        chooseMyLocationButton.isHidden = true
        mapView.delegate = self
        getUserLocation { [weak self] location in
            DispatchQueue.main.async { guard let strongSelf = self else { return }
                strongSelf.mapView.setRegion (MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            }
        }
    }
    
    @IBAction func chooseMyLocationButtonPressed(_ sender: UIButton) {
        getUserLocation { [weak self] location in DispatchQueue.main.async {
            guard let strongSelf = self else { return }
            strongSelf.mapView.setRegion (MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            strongSelf.resolveUserLocationName(with: location )
                { [weak self] locationName in
                self?.chosenLocationTextField.text = locationName }
            }
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func typeMaps(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            mapView.mapType = MKMapType.standard
        } else if (sender as AnyObject).selectedSegmentIndex == 1 {
            mapView.mapType = MKMapType.hybrid
        }
    }

    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        guard let viewContoller = UIStoryboard(name: "ShortDescription", bundle: nil).instantiateInitialViewController() as? ShortDescriptionViewController
        else { return }
        guard
            let location = chosenLocationTextField.text,
            !location.isEmpty
        else {
            self.sendOkAlert(message: Constants.Alerts.pleaseChooseLocationMessasge)
            return
        }
        createEventObject.eventLocation = location
        viewContoller.createEventObject = createEventObject
        navigationController?.pushViewController(viewContoller, animated: true)
    }
    
    public func resolveUserLocationName(
        with location: CLLocation,
        completion: @escaping ((String?) -> Void)) {
            var chosenLocationAddress = ""
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks,
                error in
                guard let place = placemarks?.first, error == nil else {
                    completion(nil)
                    return
                }
                if let name = place.name {
                    chosenLocationAddress += name
                }
                if let city = place.locality{
                    chosenLocationAddress += ", \(city)"
                }
                completion(chosenLocationAddress)
            }
        }
}

extension LocationViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        chosenLocationTextField.text = place.formattedAddress
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.mapView.addAnnotation(annotation)
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        return
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { return false }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        completion?(location)
        chooseMyLocationButton.isHidden = false
        manager.stopUpdatingLocation()
    }
}


