//
//  Pot.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/28/21.
//

import Foundation

class Pot: ObservableObject, Identifiable {
    @Published var plantName: String
    @Published var plantType: String
    @Published var idealTempLow: String
    @Published var curTemp: String
    @Published var idealTempHigh: String
    @Published var idealMoistureLow: String
    @Published var curMoisture: String
    @Published var idealMoistureHigh: String
    @Published var idealLightLow: String
    @Published var curLight: String
    @Published var idealLightHigh: String
    @Published var lastWatered: Date
    @Published var automaticWatering: Bool
    @Published var records: [Record]
    @Published var notifications: [Notification]
    

    init(plantName: String, plantType: String, idealTempHigh: String, idealTempLow: String, idealMoistureHigh: String, idealMoistureLow: String, idealLightHigh: String, idealLightLow: String) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = "65"
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = "60"
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = "3000"
        self.idealLightHigh = idealLightHigh
        self.lastWatered = Date()
        self.automaticWatering = true
        self.records = [Record(), Record()]
        self.notifications = [Notification(), Notification()]
    }
    
    func editPlant(plantName: String, plantType: String, idealTempHigh: String, idealTempLow: String, idealMoistureHigh: String, idealMoistureLow: String, idealLightHigh: String, idealLightLow: String) {
        self.plantName = plantName
        self.plantType = plantType
        self.curTemp = "65"
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.curMoisture = "60"
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.curLight = "3000"
        self.idealLightHigh = idealLightHigh
        self.lastWatered = Date()
        self.automaticWatering = true
        self.records = [Record(), Record()]
        self.notifications = [Notification(), Notification()]
    }
    
}

