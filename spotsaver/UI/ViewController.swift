//
//  ViewController.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    let locationManager = CLLocationManager()
    var mapLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.saveLabel.isHidden = true
        
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    private func canTakeLocation() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        }
        return false;
    }
    
    @IBAction func appleMaps(_ sender: Any) {
        //put this to got to applemaps
        if let loc = InfoSaver.getLocation() {
            let mapItem = loc.createMapItem()
            let regionDistance:CLLocationDistance = 10000

            let regionSpan = MKCoordinateRegion(center: mapItem.placemark.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            
            mapItem.name = "Parking Spot"
            mapItem.openInMaps(launchOptions: options)
        } else {
            AlertManager.alertNoInfo(for: self)
            return
        }
    }
    @IBAction func gmaps(_ sender: Any) {
        if let loc = InfoSaver.getLocation() {
            googleOpen(place: loc)
        } else {
            AlertManager.alertNoInfo(for: self)
            return
        }
    }
    @IBAction func waze(_ sender: Any) {
        if let loc = InfoSaver.getLocation() {
            if UIApplication.shared.canOpenURL(URL(string: "https://waze.com")!) {
                let coords = loc.coordinate
                // Waze is installed. Launch Waze and start navigation
                let urlStr: String = "https://www.waze.com/ul?ll\(coords.latitude)%2C\(coords.longitude)&navigate=yes"
//                UIApplication.shared.openURL(URL(string: urlStr)!)
                guard let url = URL(string: urlStr)
                    else {
                    return }
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // Waze is not installed. Alert the user
                AlertManager.alertNoWaze(for: self)
            }
        } else {
            AlertManager.alertNoInfo(for: self)
            return
        }
    }
    
    @IBOutlet weak var saveLabel: UILabel!
    var counter: Int!
    var timer: Timer!
//    @IBOutlet weak var coordLabel: UILabel!
    
    @IBAction func saveCurrentLocation(_ sender: Any) {
        if let loc = getCurrentLocation() {
            InfoSaver.save(place: loc)
            print("updated")
//            coordLabel.text = InfoSaver.getLocation()!.coordString()
            if mapLoaded {
                loadMap("sender")
            }
            saveLabel.isHidden = false
            counter = 0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        } else {
            print("error in retrieving location")
        }
    }
    @objc func fireTimer() {
        if counter == 5 {
            saveLabel.isHidden = true
            timer.invalidate()
            return
        }
        counter += 1
    }
    
    func getCurrentLocation() -> Pin? {
        if canTakeLocation() {
            locationManager.requestLocation()
            if let location = locationManager.location {
                let coords = location.coordinate
                return Pin(longitude: (coords.longitude), latitude: (coords.latitude))
            }
        } else {
            AlertManager.alertNoLocation(for: self)
        }
        
        return nil
    }
    
    func googleOpen(place: Pin) {
        
        guard let url = URL(string: "http://www.google.com/maps/?q=\(place.latitude),\(place.longitude)") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBOutlet weak var mapArea: UIView!
    @IBOutlet weak var mapLoadButton: UIButton!
    
    @IBAction func loadMap(_ sender: Any) {
        mapLoadButton.isHidden = true
        let mapView = MKMapView(frame: mapArea.frame)
        if let curLoc = InfoSaver.getLocation() {
            let annotation = MKPointAnnotation()
            annotation.coordinate = curLoc.coordinate
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.075, longitudeDelta: 0.075)
            let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        mapView.showsUserLocation = true
        self.view.addSubview(mapView)
        mapLoaded = true
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("\(long),\(lat)")
        } else {
            print("No coordinates")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ok oh boy thats a prob but...")
    }
}

extension ViewController: MKMapViewDelegate {
    
}
