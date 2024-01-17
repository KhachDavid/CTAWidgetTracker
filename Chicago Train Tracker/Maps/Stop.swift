//
//  Stop.swift
//  Chicago Train Tracker
//
//  Created by David Khachatryan on 12/17/23.
//

import Foundation

class Stop {
    var stopID: String
    var directionID: String
    var stopName: String
    var stationName: String
    var stationDescriptiveName: String
    var mapID: String
    var ada: Bool
    var latitude: Double
    var longitude: Double
    var red: Bool
    var blue: Bool
    var green: Bool
    var brown: Bool
    var purple: Bool
    var purpleExp: Bool
    var yellow: Bool
    var pink: Bool
    var orange: Bool

    init(stopID: String, directionID: String, stopName: String, stationName: String, stationDescriptiveName: String, mapID: String, ada: Bool, latitude: Double, longitude: Double, red: Bool, blue: Bool, green: Bool, brown: Bool, purple: Bool, purpleExp: Bool, yellow: Bool, pink: Bool, orange: Bool) {
        self.stopID = stopID
        self.directionID = directionID
        self.stopName = stopName
        self.stationName = stationName
        self.stationDescriptiveName = stationDescriptiveName
        self.mapID = mapID
        self.ada = ada
        self.latitude = latitude
        self.longitude = longitude
        self.red = red
        self.blue = blue
        self.green = green
        self.brown = brown
        self.purple = purple
        self.purpleExp = purpleExp
        self.yellow = yellow
        self.pink = pink
        self.orange = orange
    }

    // Class function to read data from CSV file and create instances of Stop class
    class func readFromCSVFile(_ filename: String) -> [Stop]? {
        do {
            guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "csv") else {
                print("File not found")
                return nil
            }

            let data = try String(contentsOf: fileURL)
            var stops: [Stop] = []

            let lines = data.components(separatedBy: "\n")

            for line in lines.dropFirst() {
                let components = line.components(separatedBy: ",")
                if components.count == 18 {
                    let stop = Stop(stopID: components[0],
                                    directionID: components[1],
                                    stopName: components[2],
                                    stationName: components[3],
                                    stationDescriptiveName: components[4],
                                    mapID: components[5],
                                    ada: components[6].lowercased() == "true",
                                    latitude: Double(components[16]
                                        .replacingOccurrences(of: "\"", with: "")
                                        .replacingOccurrences(of: "(", with: "")
                                        .replacingOccurrences(of: ")", with: "")
                                        .trimmingCharacters(in: .whitespaces)) ?? 0.0,
                                    longitude: Double(components[17]
                                        .replacingOccurrences(of: "\"", with: "")
                                        .replacingOccurrences(of: "(", with: "")
                                        .replacingOccurrences(of: ")", with: "")
                                        .trimmingCharacters(in: .whitespaces)) ?? 0.0,
                                    red: components[7].lowercased() == "true",
                                    blue: components[8].lowercased() == "true",
                                    green: components[9].lowercased() == "true",
                                    brown: components[10].lowercased() == "true",
                                    purple: components[11].lowercased() == "true",
                                    purpleExp: components[12].lowercased() == "true",
                                    yellow: components[13].lowercased() == "true",
                                    pink: components[14].lowercased() == "true",
                                    orange: components[15].lowercased() == "true")

                    stops.append(stop)
                }
            }

            return stops

        } catch {
            print("Error reading CSV file: \(error)")
            return nil
        }
    }
}
