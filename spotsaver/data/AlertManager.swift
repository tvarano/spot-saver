//
//  AlertManager.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/24/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation.CLLocationManager

class AlertManager {
    static func alertNoInfo(for caller: UIViewController) {
        let alert = UIAlertController(title: "No Location Saved", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        caller.present(alert, animated: true)
    }
    
    static func alertNoLocation(for caller: UIViewController) {
        let alert = UIAlertController(title: "Cannot Retrieve Location", message: "Check your connection and privacy settings, then try again.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(title: "Open Settings", style: .default) {
                UIAlertAction in
                AlertManager.openLocationSettings()
        })
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        
        caller.present(alert, animated: true)
    }
    
    
    static func alertNoWaze(for caller: UIViewController) {
        let alert = UIAlertController(title: "Could not find Waze", message: "Please try with another app.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        caller.present(alert, animated: true)
    }
    
    
    private static func openLocationSettings() {
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.openURL(url)
            }
        } else {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                // If general location settings are enabled then open location settings for the app
                UIApplication.shared.openURL(url)
            }
        }
    }
}
