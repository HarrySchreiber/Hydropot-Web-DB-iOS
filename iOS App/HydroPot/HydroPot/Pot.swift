//
//  Pot.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/28/21.
//

import Foundation

/*
    codable to handle JSON from db
 */
struct codePot: Codable, Identifiable {
    let image: String //image for the pot
    let plantType: String //type of plant it is
    let idealTempHigh: Int //high temperature for the pot
    let idealTempLow: Int //low temperature for the pot
    let idealMoistureHigh : Int //high moisture for the pot
    let idealMoistureLow: Int //low moisture for the pot
    let idealLightHigh: Int //high light for the pot
    let idealLightLow: Int //low light for the pot
    let id: String //id of the pot
    let automaticWatering: Bool //automatic watering bool for the pot
    let plantName: String //name of the pot
    let lastFilled: String? //last time the pot recieved a notification
    let notiFilledFrequency: Int? //the frequency of the notifications (1 week/2 weeks /3 weeks /4 weeks)
    let records: [codeRecord]? //records for the pot
    let notifications: [codeNotification]? //notifications for the pot
    
    //confomrs to codable
    enum CodingKeys: String, CodingKey {
        case plantName, plantType, idealTempLow, idealTempHigh, idealMoistureHigh, idealLightLow, idealLightHigh, automaticWatering, idealMoistureLow, id, image, records, notifications, lastFilled, notiFilledFrequency
    }
}

/*
    class to hold pot objects
 */
class Pot: ObservableObject, Identifiable {
    @Published var image: String //image for the pot
    @Published var plantType: String //type of plant it is
    @Published var idealTempHigh: Int //high temperature for the pot
    @Published var idealTempLow: Int //low temperature for the pot
    @Published var curTemp: Int //the current temp of the pot
    @Published var idealMoistureHigh : Int //high moisture for the pot
    @Published var idealMoistureLow: Int //low moisture for the pot
    @Published var curMoisture: Int //the current moisture of the pot
    @Published var idealLightHigh: Int //high light for the pot
    @Published var idealLightLow: Int //low light for the pot
    @Published var curLight: Int //the current light of the pot
    @Published var resLevel: Int //the resLevel of the pot
    @Published var id: String //id of the pot
    @Published var automaticWatering: Bool //automatic watering bool for the pot
    @Published var lastWatered: Date //the last date the pot was waterd
    @Published var plantName: String //name of the pot
    @Published var records: [Record] //records for the pot
    @Published var notifications: [Notification] //notifications for the pot
    @Published var lastFilled: Date //last time the pot recieved a notification
    @Published var notiFilledFrequency: Int //the frequency of the notifications (1 week/2 weeks /3 weeks /4 weeks)
    
    /// constructor for pot
    ///
    /// - Parameters:
    ///     - image: Image for the pot
    ///     - plantType: Type of plant it is
    ///     - idealTempHigh: High temp for the pot
    ///     - idealTempLow: Low temperature for the pot
    ///     - curTemp: The current temp of the pot
    ///     - idealMoistureHigh: High moisture for the pot
    ///     - idealMoistureLow: Low moisture for the pot
    ///     - curMoisture: The current moisture for the pot
    ///     - idealLightHigh: High light for the pot
    ///     - idealLightLow: Low light for the pot
    ///     - curLight: The current light of the pot
    ///     - resLevel: The resLevel of the pot
    ///     - id: The pot id
    ///     - automaticWatering: Automatic watering bool for the pot
    ///     - lastWatered: The last date the pot was watered
    ///     - plantName: The name of the pot
    ///     - records: The records for the pot
    ///     - Notifications: The notifications for the pot
    ///     - lastFilled: The last time the pot recieved a notification
    ///     - notiFilledFrequency: The frequency of notis to be filled
    init(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int, lastWatered: Date, records: [Record], notifications: [Notification], resLevel: Int, curTemp: Int, curLight: Int, curMoisture: Int, id: String, automaticWatering: Bool, image: String, potId: String, lastFilled: Date, notiFilledFrequency: Int) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = curTemp
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = curMoisture
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = curLight
        self.idealLightHigh = idealLightHigh
        self.lastWatered = lastWatered
        self.automaticWatering = automaticWatering
        self.records = records
        self.notifications = notifications
        self.resLevel = resLevel
        self.id = potId
        self.image = image
        self.lastFilled = lastFilled
        self.notiFilledFrequency = notiFilledFrequency
    }
    
    /// editing the pott
    ///
    /// - Parameters:
    ///     - plantType: Type of plant it is
    ///     - idealTempHigh: High temp for the pot
    ///     - idealTempLow: Low temperature for the pot
    ///     - curTemp: The current temp of the pot
    ///     - idealMoistureHigh: High moisture for the pot
    ///     - idealMoistureLow: Low moisture for the pot
    ///     - curMoisture: The current moisture for the pot
    ///     - idealLightHigh: High light for the pot
    ///     - idealLightLow: Low light for the pot
    ///     - curLight: The current light of the pot
    ///     - plantName: The name of the pot
    func editPlant(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int) {
        self.plantName = plantName
        self.plantType = plantType
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.curTemp = 0
        self.idealMoistureLow = idealMoistureLow
        self.idealMoistureHigh = idealMoistureHigh
        self.curMoisture = 0
        self.idealLightLow = idealLightLow
        self.idealLightHigh = idealLightHigh
        self.curLight = 0
    }
    
    /// editing the pott another way
    ///
    /// - Parameters:
    ///     - plantType: Type of plant it is
    ///     - idealTempHigh: High temp for the pot
    ///     - idealTempLow: Low temperature for the pot
    ///     - curTemp: The current temp of the pot
    ///     - idealMoistureHigh: High moisture for the pot
    ///     - idealMoistureLow: Low moisture for the pot
    ///     - curMoisture: The current moisture for the pot
    ///     - idealLightHigh: High light for the pot
    ///     - idealLightLow: Low light for the pot
    ///     - curLight: The current light of the pot
    ///     - plantName: The name of the pot
    ///     - automaticWatering: Automatic watering bool for the pot
    ///     - lastWatered: The last date the pot was watered
    ///     - image: Image for the pot
    func editPlant(plantName: String, plantType: String, idealTempHigh: Int, idealTempLow: Int, idealMoistureHigh: Int, idealMoistureLow: Int, idealLightHigh: Int, idealLightLow: Int, curLight: Int, curMoisture: Int, curTemp: Int, automaticWatering: Bool, lastWatered: Date, image: String) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = curTemp
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = curMoisture
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = curLight
        self.idealLightHigh = idealLightHigh
        self.automaticWatering = automaticWatering
        self.lastWatered = lastWatered
        self.image = image
    }
    
    
    func getValues(unit: String) -> [(high: Int, avg: Int, low: Int)] {
        if records.count != 0 {
            //print(self.plantName)
            var maxLight = Int.min
            var minLight = Int.max
            var maxTemp = Int.min
            var minTemp = Int.max
            var maxMoisture = Int.min
            var minMoisture = Int.max
            
            //lists
            var listForAvgLight : [Int] = []
            var listForAvgTemp : [Int] = []
            var listForAvgMoisture : [Int] = []
            
            //records being sorted by date
            var recordsList = records
            recordsList = recordsList.sorted(by: {
                $0.dateRecorded.compare($1.dateRecorded) == .orderedDescending
            })
            
            for record in recordsList {
                //let date1 = record.dateRecorded
                //let date2 = Date()
                
                //let diffs = Calendar.current.dateComponents([.day, .hour], from: date1, to: date2)
                //let days = diffs.day ?? 0
                //let hours = diffs.hour ?? 0
                //print("days and hours behind: \(days), \(hours)")
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
//                print("----------")
//                print(record.moisture)
//                print(record.light)
//                print(record.temperature)
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
            
            //tuples
            let lightTuple = (high: maxLight, avg: avgLight, low: minLight)
            let tempTuple = (high: maxTemp, avg: avgTemp, low: minTemp)
            let moistureTuple = (high: maxMoisture, avg: avgMoisture, low: minMoisture)
            
//            print(lightTuple)
//            print("------------")
//            print([moistureTuple, lightTuple, tempTuple])
            return [moistureTuple, lightTuple, tempTuple]
        }
        return [(high: 0, avg: 0, low: 0), (high: 0, avg: 0, low: 0), (high: 0, avg: 0, low: 0)]
    }
}


