//
//  MapPin.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/17/23.
//

import Foundation
import MapKit

class MapPin: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
}
