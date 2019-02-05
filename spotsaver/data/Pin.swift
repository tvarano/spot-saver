//
//  Location.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, NSCoding {
    // coding vals
    static let Dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = Dir.appendingPathComponent("place")

    //coordinate of the pin
    var coordinate: CLLocationCoordinate2D
    
    //convenience values
    var longitude: Double {
        get {
            return coordinate.longitude.magnitude
        }
        set(input) {
            coordinate.longitude = CLLocationDegrees(longitude)
        }
    }
    var latitude: Double {
        get {
            return coordinate.latitude.magnitude
        }
        set {
            coordinate.latitude = CLLocationDegrees(latitude)
        }
    }
    //name
    var name: String
    
    // initialize with individual vals
    init(longitude: Double, latitude: Double) {
        coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        name = ""
    }
    
    // init from a copy
    init(from other: Pin) {
        self.coordinate = other.coordinate
        self.name = other.name
    }
    
    // init from a string LIKELY DEPRECATED
    init(coords: String) {
        let index = (coords.firstIndex(of: ","))!//?.encodedOffset)!
        
        print("long:\(coords.prefix(upTo: index)) , lat:\(coords.suffix(from: String.Index(encodedOffset: index.encodedOffset + 1)))")
        
        let long = Double(coords.prefix(upTo: index))!
        
        let lat = Double(coords.suffix(from: String.Index(encodedOffset: index.encodedOffset + 1)))!
        
        coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))

        name = ""
    }
    
    //encoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self, forKey: "coords")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let copy = aDecoder.decodeObject(forKey: "coords") as! Pin
        self.init(from: copy)
    }
    
    // create map item for overlays
    func createMapItem() -> MKMapItem {
        return MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
    }
    
    //create string for coordinatess
    func coordString() -> String {
        return "\(longitude),\(latitude)"
    }
}

class PinManager: NSObject, UITableViewDelegate, NSCoding {
    //encoding vals
    static let Dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = Dir.appendingPathComponent("pinManager")
    // pin values held
    var vals: [Pin]
    
    override init() {
        vals = []
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self, forKey: "pinman")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        copyData(from: aDecoder.decodeObject(forKey: "pinman") as! PinManager)
    }
    
    private func copyData(from other: PinManager) {
        self.vals = other.vals
    }
}
