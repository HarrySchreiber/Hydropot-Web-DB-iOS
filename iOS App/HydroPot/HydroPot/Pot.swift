//
//  Pot.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/28/21.
//

import Foundation

struct codePot: Codable, Identifiable {
    let curLight: Int
    let curMoisture: Int
    let image: String
    let idealLightHigh: Int
    let curTemp: Int
    let lastWatered: String
    let plantType: String
    let idealMoistureHigh : Int
    let idealMoistureLow: Int
    let idealTempLow: Int
    let idealLightLow: Int
    let id: String
    let automaticWatering: Bool
    let plantName: String
    let idealTempHigh: Int
    let records: [codeRecord]?
    let notifications: [codeNotification]?

    enum CodingKeys: String, CodingKey {
        case plantName, plantType, idealTempLow, curTemp, idealTempHigh, curMoisture, idealMoistureHigh, idealLightLow, curLight, idealLightHigh, lastWatered, automaticWatering, idealMoistureLow, id, image, records, notifications
    }
}

class Pot: ObservableObject, Identifiable {
    @Published var plantName: String
    @Published var plantType: String
    @Published var idealTempLow: Int
    @Published var curTemp: Int
    @Published var idealTempHigh: Int
    @Published var idealMoistureLow: Int
    @Published var curMoisture: Int
    @Published var idealMoistureHigh: Int
    @Published var idealLightLow: Int
    @Published var curLight: Int
    @Published var idealLightHigh: Int
    @Published var lastWatered: Date
    @Published var automaticWatering: Bool
    @Published var records: [Record]
    @Published var notifications: [Notification]
    @Published var image: String
    @Published var id: String
    

    init(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int, lastWatered: Date, records: [Record], notifications: [Notification]) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = 65
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = 60
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = 3000
        self.idealLightHigh = idealLightHigh
        self.lastWatered = lastWatered
        self.automaticWatering = true
        self.records = records
        self.notifications = notifications
        self.image = ""
        self.id = UUID().uuidString
    }
    
    func editPlant(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = 65
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = 60
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = 3000
        self.idealLightHigh = idealLightHigh
        self.lastWatered = Date()
        self.automaticWatering = true
    }
    
    
    func getValues(unit: String) -> [(high: Int, avg: Int, low: Int)] {
        
        print(self.plantName)
        var maxLight = Int.min
        var minLight = Int.max
        var maxTemp = Int.min
        var minTemp = Int.max
        var maxMoisture = Int.min
        var minMoisture = Int.max
        
        var listForAvgLight : [Int] = []
        var listForAvgTemp : [Int] = []
        var listForAvgMoisture : [Int] = []
        
        var recordsList = records
        recordsList = recordsList.sorted(by: {
            $0.dateRecorded.compare($1.dateRecorded) == .orderedDescending
        })

        for record in recordsList {
            let date1 = record.dateRecorded
            let date2 = Date()
            
            let diffs = Calendar.current.dateComponents([.day, .hour], from: date1, to: date2)
            let days = diffs.day ?? 0
            let hours = diffs.hour ?? 0
            print("days and hours behind: \(days), \(hours)")
            //if not in range anymore
//            if unit == "Hourly" && hours >= 12 {
//                break
//            }
//
//            if unit == "Daily" && days >= 7 {
//                break
//            }
//
//            if unit == "Weekly" && days >= 35 {
//                break
//            }
            
            //if still in range
            //get min/max for light
            if record.light < minLight {
                minLight = record.light
            }
            if record.light > maxLight {
                maxLight = record.light
            }
            listForAvgLight.append(record.light)
            
            //get min/max for temp
            if record.temperature < minTemp {
                minTemp = record.temperature
            }
            if record.temperature > maxTemp {
                maxTemp = record.temperature
            }
            print("----------")
            print(record.moisture)
            print(record.light)
            print(record.temperature)
            listForAvgTemp.append(record.temperature)
            
            //get min/max for moisture
            if record.moisture < minMoisture {
                minMoisture = record.moisture
            }
            if record.moisture > maxMoisture {
                maxMoisture = record.moisture
            }
            listForAvgMoisture.append(record.moisture)
        }//end for loop through records
        
        //get averages
        //light
        let sumLight = listForAvgLight.reduce(0, +)
        let avgLight = sumLight / listForAvgLight.count
        //temp
        let sumTemp = listForAvgTemp.reduce(0, +)
        let avgTemp = sumTemp / listForAvgTemp.count
        //moisture
        let sumMoisture = listForAvgMoisture.reduce(0, +)
        let avgMoisture = sumMoisture / listForAvgMoisture.count
        
        let lightTuple = (high: maxLight, avg: avgLight, low: minLight)
        let tempTuple = (high: maxTemp, avg: avgTemp, low: minTemp)
        let moistureTuple = (high: maxMoisture, avg: avgMoisture, low: minMoisture)
        
        print(lightTuple)
        print("------------")
        print([moistureTuple, lightTuple, tempTuple])
        return [moistureTuple, lightTuple, tempTuple]
    }
    
}

