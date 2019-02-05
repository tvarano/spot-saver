//
//  MapOverlay.swift
//  spotsaver
//
//  Created by Thomas Varano on 11/23/18.
//  Copyright © 2018 Thomas Varano. All rights reserved.
//

import Foundation
import MapKit

class MapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(with pin: Pin) {
        coordinate = pin.coordinate
        boundingMapRect = MKMapRect(origin: MKMapPoint(coordinate), size: MKMapSize(width: 25, height: 25))
    }
}
