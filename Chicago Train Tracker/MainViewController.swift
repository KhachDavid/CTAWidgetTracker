//
//  MainViewController.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/12/23.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

