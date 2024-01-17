//
//  MapView.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/20/23.
//

import Foundation
import UIKit
import MapKit

class MapView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let mapView = MKMapView()
    private var locationManager: LocationManager! = nil
    private let centerButton = UIButton(type: .system)
    private var closestStop: Stop?
    private var closestDistance: CLLocationDistance = Double.infinity
    
    public func configureView() {
        // Set up constraints for mapView and centerButton above the tab bar
        
            mapView.translatesAutoresizingMaskIntoConstraints = false
            centerButton.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(mapView)
            view.addSubview(centerButton)
            
            NSLayoutConstraint.activate([
                mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                mapView.topAnchor.constraint(equalTo: view.topAnchor),
                mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Use the passed parameter
                
                centerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                centerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        // Usage example:
        if let stops = Stop.readFromCSVFile("train_stops"), let currentLocationCoordinate = locationManager.getLocationManager().location?.coordinate {
            // Accessing the parsed data

            let currentLocation = CLLocation(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude)

            for stop in stops {
                // Trim leading and trailing whitespaces from latitude and longitude strings
                
                let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)

                // Calculate the distance between the current location and the stop
                let distance = currentLocation.distance(from: stopLocation)

                // Check if this stop is closer than the previous closest one
                if distance < closestDistance {
                    closestDistance = distance
                    closestStop = stop
                }
            }

            let currentLocation2 = CLLocationCoordinate2D(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude)
            // Show directions if a closest stop is found
            if let closestStop = closestStop {
                showRouteOnMap(pickupCoordinate: currentLocation2, destinationCoordinate: CLLocationCoordinate2D(latitude: closestStop.latitude, longitude: closestStop.longitude))
            }

        } else {
            print("Failed to read data from CSV file.")
        }

        mapView.region = locationManager.region
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.delegate = self
        
        view.addSubview(mapView)
        // Set up the center button
        centerButton.setTitle("Center", for: .normal)
        centerButton.addTarget(self, action: #selector(centerMapOnUserLocation), for: .touchUpInside)
        view.addSubview(centerButton)

        // Activate constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        centerButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func centerMapOnUserLocation() {
        // Trigger the centering of the map on the user's location
        locationManager.centerMapOnUserLocation(mapView: mapView)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                //for getting just one route
                if let route = unwrappedResponse.routes.first {
                    //show on map
                    self.mapView.addOverlay(route.polyline)
                    //set the map area to show the route
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }

                //if you want to show multiple routes then you can get all routes in a loop in the following statement
                //for route in unwrappedResponse.routes {}
            }
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.systemBlue
         renderer.lineWidth = 15.0
         return renderer
    }
}
