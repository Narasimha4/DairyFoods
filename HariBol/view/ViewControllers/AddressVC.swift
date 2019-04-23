//
//  AddressVC.swift
//  HariBol
//
//  Created by Narasimha on 31/12/18.
//  Copyright © 2018 haribol. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView

class AddressVC: UIViewController, NVActivityIndicatorViewable, UISearchBarDelegate {
    
    @IBOutlet weak var addressInfoLabel: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var pincodeLabel: UITextField!
    @IBOutlet weak var stateLabel: UITextField!
    @IBOutlet weak var landmarkLabel: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let marker = GMSMarker()
    var locationManager = CLLocationManager()
    let googlePlacesapiKey = "AIzaSyDkdGbfToIXK8LPobV_tuQlosotKgGXG0k"
    var markerSnippet :String?
    var markerTitle:String?
    var navflow:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimate()
        // Do any additional setup after loading the view.
        self.title = "Add Your Address"
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        mapViewSetUp()
        confirmButton.layerBorder()
        addressLabel.layer.borderColor = UIColor.black.cgColor
        addressLabel.layer.borderWidth = 2.0
        addressLabel.setLeftPaddingPoints(5)
        addressInfoLabel.layer.borderColor = UIColor.black.cgColor
        addressInfoLabel.layer.borderWidth = 2.0
        addressInfoLabel.setLeftPaddingPoints(5)
        landmarkLabel.layer.borderColor = UIColor.black.cgColor
        landmarkLabel.layer.borderWidth = 2.0
        landmarkLabel.setLeftPaddingPoints(5)
        stateLabel.layer.borderColor = UIColor.black.cgColor
        stateLabel.layer.borderWidth = 2.0
        stateLabel.setLeftPaddingPoints(5)
        pincodeLabel.layer.borderColor = UIColor.black.cgColor
        pincodeLabel.layer.borderWidth = 2.0
        pincodeLabel.setLeftPaddingPoints(5)
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        if flowVar == "address" {
            let addButton = UIBarButtonItem(image:UIImage(named:"left"), style:.plain, target:self, action:#selector(AddressVC.buttonAction(_:)))
            addButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = addButton
            self.navigationController?.navigationBar.tintColor = UIColor.white
        } else {
            flowVar = "normal"
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc func buttonAction(_ sender: UIBarButtonItem) {
        print("dismiss")
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        self.present(placePickerController, animated: true, completion: nil)
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //startAnimate()
    }
    
    func startAnimate() {
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Please wait...", type:.ballRotateChase, fadeInAnimation: nil)
    }
    
    func mapViewSetUp() {
        initializeTheLocationManager()
        mapView.settings.indoorPicker = true
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        
        // Creates a marker in the center of the map.
        mapView.delegate = self
        
        if markerTitle != nil && markerSnippet != nil {
            marker.title = markerTitle
            marker.snippet = markerSnippet
        }
        
        marker.isDraggable = true
        marker.icon = UIImage(named: "marker")
        marker.map = mapView
        
        //marker.map = mapsView
        locationManager.distanceFilter = 100
        
        // GOOGLE MAPS SDK: COMPASS
        mapView.settings.compassButton = true
        
        // GOOGLE MAPS SDK: USER'S LOCATION
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        // GOOGLE MAPS SDK: BORDER
        let mapInsets = UIEdgeInsets(top: 60.0, left: 0.0, bottom: 45.0, right: 0.0)
        mapView.padding = mapInsets
    }
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locationManager.location?.coordinate
        let address  = getAddressForLatLng(latitude: "\(location!.latitude)", longitude: "\(location!.longitude)")
        DispatchQueue.main.async {
            self.stopAnimating(nil)
        }
//        UserDefaults.standard.set(address[0] + "" + address[1], forKey: "address")
        let camera = GMSCameraPosition.camera(withLatitude: location!.latitude,longitude: location!.longitude, zoom: 15)
        mapView.camera = camera
        //marker.position = CLLocationCoordinate2D(latitude: location!.latitude, longitude: location!.longitude)
        cameraMoveToLocation(toLocation: location)
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 15)
        }
    }
    
    func getAddressForLatLng(latitude: String, longitude: String) -> [String] {
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(googlePlacesapiKey)")
        UserDefaults.standard.set(longitude, forKey: "longitude")
        UserDefaults.standard.set(latitude, forKey: "latitude")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var number = ""
                            var street = ""
                            var city = ""
                            var state = ""
                            var zip = ""
                            print(address)
                            if(address.count > 1) {
                                number =  (address.object(at: 0) as! NSDictionary)["short_name"] as! String
                                UserDefaults.standard.set(number + ",", forKey: "dno")
                                addressLabel.text = number
                            }
                            if(address.count > 2) {
                                street = (address.object(at: 1) as! NSDictionary)["short_name"] as! String
                                UserDefaults.standard.set(street + ",", forKey: "street")
                                addressInfoLabel.text = street
                            }
                            if(address.count > 3) {
                                city = (address.object(at: 2) as! NSDictionary)["short_name"] as! String
                                markerSnippet = city
                                UserDefaults.standard.set(city + ",", forKey: "city")
                                addressInfoLabel.text = addressInfoLabel.text! + "," + city
                            }
                            if(address.count > 4) {
                                state = (address.object(at: 4) as! NSDictionary)["short_name"] as! String
                                markerTitle = state
                                UserDefaults.standard.set(state, forKey: "state")
                                stateLabel.text = state
                            }
                            zip =  (address.lastObject as! NSDictionary)["short_name"] as! String
                            UserDefaults.standard.set(zip, forKey: "zip")
                            pincodeLabel.text = zip
                            newaddress = "\(street), \(city), \(state) \(zip)"
                            self.searchBar.text = number + "," + "" + newaddress
                            return [number, newaddress]
                        }
                        else {
                            return [""]
                        }
                    }
                } else {
                    return [""]
                }
            }
            else {
                return [""]
            }
            
        }   else {
            return [""]
        }
    }
    
    func updateMarker(coordinates: CLLocationCoordinate2D, degrees: CLLocationDegrees, duration: Double) {
        // Keep Rotation Short
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        marker.rotation = degrees
        CATransaction.commit()
        
        // Movement
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        marker.position = coordinates
        
        // Center Map View
        let camera = GMSCameraUpdate.setTarget(coordinates)
        mapView.animate(with: camera)
        _ = getAddressForLatLng(latitude: "\(coordinates.latitude)", longitude: "\(coordinates.longitude)")
        CATransaction.commit()
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        startAnimate()
        guard let address = UserDefaults.standard.value(forKey: "dno") as? String,
            let long_address = UserDefaults.standard.value(forKey: "street") as? String,
            let state = UserDefaults.standard.value(forKey: "state") as? String,
            let city = UserDefaults.standard.value(forKey: "city") as? String,
            let email = UserDefaults.standard.value(forKey: "email") as? String,
            let fname = UserDefaults.standard.value(forKey: "fname") as? String,
            let lname = UserDefaults.standard.value(forKey: "lname") as? String,
            let zip = UserDefaults.standard.value(forKey: "zip") as? String,
            let mobile = UserDefaults.standard.value(forKey: "mobileNumber") as? String,
            let longitude = UserDefaults.standard.value(forKey: "longitude") as? String,
            let latitude = UserDefaults.standard.value(forKey: "latitude") as? String
            else {
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                return
        }
        
        // Some parameter values are hardcoded
        // Need to take care of it
        var parameters: [String : Any] = [
            "address1": address,
            "address2": long_address,
            "city": city,
            "country": 1,
            "email": email,
            "firstName": fname,
            "landmark": landmarkLabel.text ?? "",
            "lastName": lname,
            "latitude": Double(latitude)!,
            "longitude": Double(longitude)!,
            "phone": mobile,
            "pincode": zip,
            "state": 1
        ]
    
        
        if self.navflow == nil  {
            HaribolAPI().registration(parameters: parameters,onCompletion: { (response, error) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let otpVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                self.navigationController?.pushViewController(otpVC, animated: true)
            }, onFailure: { (error) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
            })
        } else {
            guard let customerId = UserDefaults.standard.value(forKey: "customerId") else {
                return
            }
            parameters["customerId"] = customerId
            print(parameters)
            HaribolAPI().updateProfile(parameters: parameters, onCompletion: { (response, error) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
                self.dismiss(animated: true, completion: nil)
            }, onFailure: { (error) in
                DispatchQueue.main.async {
                    self.stopAnimating(nil)
                }
            })
        }
    }
}

extension AddressVC: GMSMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateMarker(coordinates: position.target, degrees: 0, duration: 0)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        updateMarker(coordinates: coordinate, degrees: 0, duration: 0)
    }
    
}


extension AddressVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        marker.position = place.coordinate
        let location = place.coordinate
        updateMarker(coordinates: location, degrees: 0, duration: 0)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
