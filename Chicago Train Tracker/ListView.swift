//
//  ListView.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/20/23.
//

import Foundation
import UIKit
import MapKit

class ListView: UIViewController, CLLocationManagerDelegate {

    private let tableView = UITableView()
    private var stops: [Stop] = []
    private var locationManager: LocationManager! = nil
    private var closestStop: Stop?
    private var closestDistance: CLLocationDistance = Double.infinity

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()

        // Set up the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        // Activate constraints
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Load data for the list view
        if var loadedStops = Stop.readFromCSVFile("train_stops"), let currentLocationCoordinate = locationManager.getLocationManager().location?.coordinate {
            locationManager = LocationManager()
            let currentLocation = CLLocation(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude)
            print(currentLocation.coordinate)
            loadedStops.sort {
                let stopLocation = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                let distance1 = currentLocation.distance(from: stopLocation)

                let stopLocation2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
                let distance2 = currentLocation.distance(from: stopLocation2)

                return distance1 < distance2
            }
            
            stops = loadedStops
            tableView.reloadData()
        } else {
            print("Failed to read data from CSV file.")
        }
    
    }
}

extension ListView: UITableViewDelegate, UITableViewDataSource {
    
    func showDetails(for stop: Stop) {
        // Create an instance of StopDetailsViewController
        let stopDetailsVC = StopDetailsViewController()
        stopDetailsVC.selectedStop = stop

        // Make API request and update details in StopDetailsViewController
        makeAPIRequest(for: stop) { etaArray in
            DispatchQueue.main.async {
                // Update UI in the main thread
                stopDetailsVC.stopDetails = etaArray
                stopDetailsVC.tableView.reloadData()
            }
        }

        // Push the StopDetailsViewController onto the navigation stack
        navigationController?.pushViewController(stopDetailsVC, animated: true)
    }

    func makeAPIRequest(for stop: Stop, completion: @escaping ([CTAApiResponse.CTATT.ETA]) -> Void) {
        let apiKey = "20024e31f9f94a518246f6bf74a90ac2"
        let urlString = "https://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=\(apiKey)&mapid=\(stop.mapID)&outputType=JSON"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CTAApiResponse.self, from: data)
                    let etaArray = response.ctatt.eta.prefix(15).map { $0 }
                    completion(Array(etaArray))
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Error making API request: \(error)")
            }
        }

        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let stop = stops[indexPath.row]
        cell.contentView.subviews.forEach{ $0.removeFromSuperview() }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8

        // Create a label
        let textLabel = UILabel()
        textLabel.text = stop.stationName

        // Create a cube view
        let cubeView = UIView()
        cubeView.backgroundColor = UIColor(red: 249/255, green: 227/255, blue: 0, alpha: 1.0)

        // Add label and cube view to stack view
        stackView.addArrangedSubview(textLabel)

        addCubeViews(stackView, for: stops[indexPath.row])

        // Add stack view to cell's content view
        cell.contentView.addSubview(stackView)

        // Position the stack view in the cell
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -20)
        ])

        return cell
    }
    
    func updateStackView(_ stackView: UIStackView, for stop: Stop) {
        // You can update the existing stack view if needed
        // For example, update cube views based on the new stop conditions
        addCubeViews(stackView, for: stop)
    }

    func addCubeViews(_ stackView: UIStackView, for stop: Stop) {
        // Add cube views based on stop conditions
        if stop.orange {
            addCubeView(stackView, color: UIColor(red: 249/255, green: 70/255, blue: 28/255, alpha: 1.0))
        }
        if stop.yellow {
            addCubeView(stackView, color: UIColor(red: 249/255, green: 227/255, blue: 0, alpha: 1.0))
        }
        if stop.red {
            addCubeView(stackView, color: UIColor(red: 198/255, green: 12/255, blue: 48/255, alpha: 1.0))
        }
        if stop.blue {
            addCubeView(stackView, color: UIColor(red: 0, green: 161/255, blue: 222/255, alpha: 1.0))
        }
        if stop.green {
            addCubeView(stackView, color: UIColor(red: 0, green: 155/255, blue: 58/255, alpha: 1.0))
        }
        if stop.brown {
            addCubeView(stackView, color: UIColor(red: 98/255, green: 54/255, blue: 27/255, alpha: 1.0))
        }
        if stop.purpleExp {
            addCubeView(stackView, color: UIColor(red: 82/255, green: 35/255, blue: 152/255, alpha: 1.0))
        }
        if stop.pink {
            addCubeView(stackView, color: UIColor(red: 226/255, green: 126/255, blue: 166/255, alpha: 1.0))
        }
    }

    func addCubeView(_ stackView: UIStackView, color: UIColor) {
        let cubeView = UIView()
        cubeView.backgroundColor = color
        cubeView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cubeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.addArrangedSubview(cubeView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStop = stops[indexPath.row]
        showDetails(for: selectedStop)
    }
}

struct CTAApiResponse: Codable {
    struct CTATT: Codable {
        struct ETA: Codable {
            let destNm: String
            let arrT: String
            let rt: String
        }
        let eta: [ETA]
    }
    let ctatt: CTATT
}
