import Foundation
import UIKit

/*
 Y  - f9e300
 Pink - e27ea6
 P - 522398
 Org - f9461c
 G - 009b3a
 Brn - 62361b
 Blue - 00a1de
 Red - c60c30
 */

extension UIColor {
    convenience init(named: String) {
        var hexSanitized = named.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


class StopDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedStop: Stop?
    var stopDetails: [CTAApiResponse.CTATT.ETA] = []  // Assuming CTAEta is the data structure for arrival information
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize this view controller to display detailed information about the selected stop
        if let stop = selectedStop {
            // Use 'stop' to populate the details on this view controller
            self.title = stop.stationName

            // Configure UITableView
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            view.addSubview(tableView)

            // Update constraints
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            
            // Configure pull-to-refresh
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            tableView.refreshControl = refreshControl

            // Assuming you have a method to fetch and populate stop details (stopDetails) from your API
            fetchStopDetails()
        }
    }
    
    @objc func refreshData() {
        // Perform actions to refresh data
        fetchStopDetails()
    }

    func fetchStopDetails() {
        // Use your API to fetch stop details and populate stopDetails array
        // For example, you can replace this with the logic to fetch data and assign it to stopDetails
        // stopDetails = ...

        // Reload the table view once data is available
        tableView.reloadData()
        
        // End refreshing
        refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(stopDetails.count, 15)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let eta = stopDetails[indexPath.row]

        // Configure the cell with destination and arrival time
        if let arrivalTime = convertStringToDate(eta.arrT) {
            let minutesUntilArrival = calculateMinutesUntilArrival(arrivalTime)
            if minutesUntilArrival < 0 {
                cell.textLabel?.text = "\(eta.destNm): Delayed"
            } else if minutesUntilArrival < 2 {
                cell.textLabel?.text = "\(eta.destNm): Due"
            } else {
                cell.textLabel?.text = "\(eta.destNm): \(minutesUntilArrival) minutes"
            }

        } else {
            cell.textLabel?.text = "\(eta.destNm), Arrival: \(eta.arrT)"
        }
        
        // Set background color based on eta.rt
        switch eta.rt {
        case "Y":
            cell.backgroundColor = UIColor(red: 249/255, green: 227/255, blue: 0, alpha: 1.0)
        case "Pink":
            cell.backgroundColor = UIColor(red: 226/255, green: 126/255, blue: 166/255, alpha: 1.0)
        case "P":
            cell.backgroundColor = UIColor(red: 82/255, green: 35/255, blue: 152/255, alpha: 1.0)
        case "Org":
            cell.backgroundColor = UIColor(red: 249/255, green: 70/255, blue: 28/255, alpha: 1.0)
        case "G":
            cell.backgroundColor = UIColor(red: 0, green: 155/255, blue: 58/255, alpha: 1.0)
        case "Brn":
            cell.backgroundColor = UIColor(red: 98/255, green: 54/255, blue: 27/255, alpha: 1.0)
        case "Blue":
            cell.backgroundColor = UIColor(red: 0, green: 161/255, blue: 222/255, alpha: 1.0)
        case "Red":
            cell.backgroundColor = UIColor(red: 198/255, green: 12/255, blue: 48/255, alpha: 1.0)
        default:
            // Set default background color
            cell.backgroundColor = UIColor.white
        }
        
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = cell.backgroundColor


        return cell
    }
    
    func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }

    func calculateMinutesUntilArrival(_ arrivalTime: Date) -> Int {
        let currentTime = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: currentTime, to: arrivalTime)
        return components.minute ?? 0
    }
}

